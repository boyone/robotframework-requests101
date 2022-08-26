# Step by Step[from shopping-cart to shopping-cart2] Step 5

- [Step #1 : แบ่งกลุ่มการทำงาน](./step-by-step-01.md)
- [Step #2 : สร้าง keyword ของการสร้าง Session](./step-by-step-02.md)
- [Step #3 : สร้าง keyword ของการเรียกดูสินค้าทั้งหมด](./step-by-step-03.md)
- [Step #4 : สร้าง keyword ของการเรียกดูข้อมูลสินค้า](./step-by-step-04.md)
- [Step #5 : สร้าง keyword ของการออเดอร์สินค้า](./step-by-step-05.md)
- [Step #6 : สร้าง keyword ของการคอนเฟิร์มสินค้า](./step-by-step-06.md)

## สร้าง keyword ของการออเดอร์สินค้า

1. ตั้งชื่อ Keyword ว่า `ออเดอร์สินค้า`

   ```robot
   *** Keywords ***
   สร้าง Session
   ...

   เรียกดูสินค้าทั้งหมด
   ...

   เรียกดูข้อมูลสินค้า
   ...

   ออเดอร์สินค้า
   ```

2. Copy `&{CONTENT}= Create Dictionary ...` ไปวางไว้ใต้ Keywords ที่ทำไว้ใน Step ที่ 1

   ```robot
   *** Keywords ***
   สร้าง Session
      ...

   เรียกดูสินค้าทั้งหมด
      ...

   เรียกดูข้อมูลสินค้า
      ...

   ออเดอร์สินค้า
      &{CONTENT}=    Create Dictionary    Content-Type=application/json
      ${order}=    POST On Session    toy_shop    api/v1/order    expected_status=200    headers=&{CONTENT}    json=&{ORDER_TEMPLATE}
      Should Be Equal As Strings    ${order.json()}[order_id]    8004359122
      Should Be Equal As Numbers    ${order.json()}[total_price]    14.95
   ```

3. แทนที่ `&{CONTENT}= Create Dictionary ...` ด้วย `ออเดอร์สินค้า`

   ```robot
   *** Test Cases ***
   Shopping Cart
      สร้าง Session
      เรียกดูสินค้าทั้งหมด
      เรียกดูข้อมูลสินค้า
      ออเดอร์สินค้า
   ```

4. ทดสอบ

   ```sh
   robot shopping-cart.robot
   ```

   - จะได้ Error ดังนี้

     ```sh
     Shopping Cart                                       | FAIL |
     Variable '&{CONTENT}' not found.
     ------------------------------------------------------------
     Shopping-Cart2                                      | FAIL |
     1 test, 0 passed, 1 failed
     ============================================================
     ```

   - เนื่องจากเราแยก `Keyword ออเดอร์สินค้า` ออกมาทำให้ตัวแปร `&{CONTENT}` โดนยกออกมาด้วย ทำให้ตัวแปร `&{CONTENT}` ที่ใช้ใน `คอนเฟิร์มสินค้า` ไม่สามารถอ้างถึงค่าได้

5. เปลี่ยนตัวแปร `&{CONTENT}` ให้อยู่ในระดับของ Test Suite เพื่อให้ทุก Keyword เรียกใช้งานได้ โดย

   - CUT `&{CONTENT}= Create Dictionary Content-Type=application/json` ไปไว้ที่ `*** Variables ***`
   - หลังจากนั้นลบ `= Create Dictionary`

   ```robot
   *** Variables ***
   &{ACCEPT}               Accept=application/json
   &{CONTENT}              Content-Type=application/json

   &{CART}                 product_id=2    quantity=1
   ```

6. ทดสอบอีกครั้ง

   ```sh
   robot shopping-cart.robot
   ```

   - จะได้ Error ดังนี้

     ```sh
     Shopping Cart                                                         | FAIL |
     Resolving variable '${order.json()}' failed: Variable '${order}' not found.
     ------------------------------------------------------------------------------
     Shopping-Cart2                                                        | FAIL |
     1 test, 0 passed, 1 failed
     ==============================================================================
     ```

   - เนื่องจากใน คอนเฟิร์มสินค้า มีการเรียกใช้ `${order.json()}[order_id]` แต่ตัวแปร `${order}` อยู่ใน Keyword `ออเดอร์สินค้า` ส่งผลให้ การคอนเฟิร์มสินค้า ไม่สามารถเรียกใช้ได้

7. ปรับให้ แต่ตัวแปร `${order.json()}[order_id]` เข้าถึงได้จาก Keywords อื่น

   - เพิ่ม `Set Test Variable ${order_id} ${orderStatus.json()["order_id"]}` เข้าไปใน Keyword ออเดอร์สินค้า

     ```robot
     ออเดอร์สินค้า
     &{CONTENT}=    Create Dictionary    Content-Type=application/json
     ${order}=    POST On Session    toy_shop    api/v1/order    expected_status=200    headers=&{CONTENT}    json=&{ORDER_TEMPLATE}
     Should Be Equal As Strings    ${order.json()}[order_id]    8004359122
     Should Be Equal As Numbers    ${order.json()}[total_price]    14.95
     Set Test Variable    ${order_id}    ${order.json()["order_id"]}
     ```

   - ปรับส่วน การคอนเฟิร์มสินค้า ใช้ตัวแปร `${order_id}` จากเดิมที่ใช้ `${order.json()}[order_id]` ใน

     ```robot
     Set To Dictionary ${CONFIRM_PAYMENT_TEMPLATE} order_id=${order.json()}[order_id]
     ```

     เป็น

     ```robot
     Set To Dictionary    ${CONFIRM_PAYMENT_TEMPLATE}    order_id=${order_id}
     ```

8. ทดสอบอีกครั้ง

   ```sh
   robot shopping-cart.robot
   ```
