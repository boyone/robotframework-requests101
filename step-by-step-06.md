# Step by Step[from shopping-cart to shopping-cart2] Step 6

- [Step #1 : แบ่งกลุ่มการทำงาน](./step-by-step-01.md)
- [Step #2 : สร้าง keyword ของการสร้าง Session](./step-by-step-02.md)
- [Step #3 : สร้าง keyword ของการเรียกดูสินค้าทั้งหมด](./step-by-step-03.md)
- [Step #4 : สร้าง keyword ของการเรียกดูข้อมูลสินค้า](./step-by-step-04.md)
- [Step #5 : สร้าง keyword ของการออเดอร์สินค้า](./step-by-step-05.md)
- [Step #6 : สร้าง keyword ของการคอนเฟิร์มสินค้า](./step-by-step-06.md)

## สร้าง keyword ของการคอนเฟิร์มสินค้า

1. ตั้งชื่อ Keyword ว่า `คอนเฟิร์มสินค้า`

   ```robot
   *** Keywords ***
   สร้าง Session
   ...

   เรียกดูสินค้าทั้งหมด
   ...

   เรียกดูข้อมูลสินค้า
   ...

   ออเดอร์สินค้า
   ...

   คอนเฟิร์มสินค้า
   ```

2. Copy `&{POST_HEADERS}= Create Dictionary ...` ไปวางไว้ใต้ Keywords ที่ทำไว้ใน Step ที่ 1

   ```robot
   *** Keywords ***
   สร้าง Session
      ...

   เรียกดูสินค้าทั้งหมด
      ...

   เรียกดูข้อมูลสินค้า
      ...

   ออเดอร์สินค้า
      ...

   คอนเฟิร์มสินค้า
      &{POST_HEADERS}=      Create Dictionary     &{ACCEPT}    &{CONTENT}
      Set To Dictionary    ${CONFIRM_PAYMENT_TEMPLATE}    order_id=${order_id}
      ${paymentStatus}=    POST On Session    toy_shop    api/v1/confirmPayment    expected_status=200    headers=&{POST_HEADERS}    json=${CONFIRM_PAYMENT_TEMPLATE}
      Should Be Equal As Strings    ${paymentStatus.json()}[notify_message]    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
   ```

3. แทนที่ `&{POST_HEADERS}= Create Dictionary ...` ด้วย `คอนเฟิร์มสินค้า`

   ```robot
   *** Test Cases ***
   Shopping Cart
      สร้าง Session
      เรียกดูสินค้าทั้งหมด
      เรียกดูข้อมูลสินค้า
      ออเดอร์สินค้า
      คอนเฟิร์มสินค้า
   ```

4. ทดสอบ

   ```sh
   robot shopping-cart.robot
   ```
