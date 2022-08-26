# Extract Keywords Step by Step: Step 4

- [Step #1 : แบ่งกลุ่มการทำงาน](./step-by-step-01.md)
- [Step #2 : สร้าง keyword ของการสร้าง Session](./step-by-step-02.md)
- [Step #3 : สร้าง keyword ของการเรียกดูสินค้าทั้งหมด](./step-by-step-03.md)
- [Step #4 : สร้าง keyword ของการเรียกดูข้อมูลสินค้า](./step-by-step-04.md)
- [Step #5 : สร้าง keyword ของการออเดอร์สินค้า](./step-by-step-05.md)
- [Step #6 : สร้าง keyword ของการคอนเฟิร์มสินค้า](./step-by-step-06.md)

## สร้าง keyword ของการเรียกดูข้อมูลสินค้า

1. ตั้งชื่อ Keyword ว่า `เรียกดูข้อมูลสินค้า`

   ```robot
   *** Keywords ***
   สร้าง Session
   ...

   เรียกดูสินค้าทั้งหมด
   ...

   เรียกดูข้อมูลสินค้า
   ```

2. Copy `&{ACCEPT}= Create Dictionary ...` ไปวางไว้ใต้ Keywords ที่ทำไว้ใน Step ที่ 1

   ```robot
   *** Keywords ***
   สร้าง Session
   ...

   เรียกดูสินค้าทั้งหมด
   ...

   เรียกดูข้อมูลสินค้า
      &{ACCEPT}=    Create Dictionary    Accept=application/json
      ${product}=    GET On Session    toy_shop    api/v1/product/2    expected_status=200    headers=&{ACCEPT}
      Should Be Equal    ${product.json()}[product_name]    43 Piece dinner Set
   ```

3. แทนที่ `&{ACCEPT}= Create Dictionary ...` ด้วย `เรียกดูข้อมูลสินค้า`

   ```robot
   *** Test Cases ***
   Shopping Cart
      สร้าง Session
      เรียกดูสินค้าทั้งหมด
      เรียกดูข้อมูลสินค้า
   ```

4. ทดสอบ

   ```sh
   robot shopping-cart.robot
   ```

   - จะได้ Error ดังนี้

     ```sh
     Shopping Cart                                       | FAIL |
     Variable '&{ACCEPT}' not found.
     ------------------------------------------------------------
     Shopping-Cart2                                      | FAIL |
     1 test, 0 passed, 1 failed
     ============================================================
     ```

   - เนื่องจากเราแยก `Keyword เรียกดูข้อมูลสินค้า` ออกมาทำให้ตัวแปร `&{ACCEPT}` โดนยกออกมาด้วย ทำให้ตัวแปร `&{ACCEPT}` ที่ใช้ใน `คอนเฟิร์มสินค้า` ไม่สามารถอ้างถึงค่าได้

5. เปลี่ยนตัวแปร `&{ACCEPT}` ให้อยู่ในระดับของ Test Suite เพื่อให้ทุก Keyword เรียกใช้งานได้ โดย

   - CUT `&{ACCEPT}= Create Dictionary Accept=application/json` ไปไว้ที่ `*** Variables ***`
   - หลังจากนั้นลบ `= Create Dictionary`

   ```robot
   *** Variables ***
   &{ACCEPT}               Accept=application/json

   &{CART}                 product_id=2    quantity=1
   ```

6. ทดสอบอีกครั้ง

   ```sh
   robot shopping-cart.robot
   ```

7. ออเดอร์สินค้า

   ```robot
   &{CONTENT}=    Create Dictionary    Content-Type=application/json
   ${order}=    POST On Session    toy_shop    api/v1/order    expected_status=200    headers=&{CONTENT}    json=&{ORDER_TEMPLATE}
   Should Be Equal As Strings    ${order.json()}[order_id]    8004359122
   Should Be Equal As Numbers    ${order.json()}[total_price]    14.95
   ```

8. คอนเฟิร์มสินค้า

   ```robot
   &{POST_HEADERS}=      Create Dictionary     &{ACCEPT}    &{CONTENT}
   Set To Dictionary    ${CONFIRM_PAYMENT_TEMPLATE}    order_id=${order.json()}[order_id]
   ${paymentStatus}=    POST On Session    toy_shop    api/v1/confirmPayment    expected_status=200    headers=&{POST_HEADERS}    json=${CONFIRM_PAYMENT_TEMPLATE}
   Should Be Equal As Strings    ${paymentStatus.json()}[notify_message]    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
   ```
