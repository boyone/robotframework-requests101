# Extract Keywords Step by Step: Step 1

- [Step #1 : แบ่งกลุ่มการทำงาน](./step-by-step-01.md)
- [Step #2 : สร้าง keyword ของการสร้าง Session](./step-by-step-02.md)
- [Step #3 : สร้าง keyword ของการเรียกดูสินค้าทั้งหมด](./step-by-step-03.md)
- [Step #4 : สร้าง keyword ของการเรียกดูข้อมูลสินค้า](./step-by-step-04.md)
- [Step #5 : สร้าง keyword ของการออเดอร์สินค้า](./step-by-step-05.md)
- [Step #6 : สร้าง keyword ของการคอนเฟิร์มสินค้า](./step-by-step-06.md)

## จาก Test case ของ Shopping Cart เราสามารถแบ่งกลุ่มการทำงานได้ดังนี้

1. การสร้าง Session

   ```robot
   Create Session    toy_shop    https://dminer.in.th
   ```

2. เรียกดูสินค้าทั้งหมด

   ```robot
   ${productList}=    GET On Session    toy_shop    api/v1/product    expected_status=200
   Should Be Equal As Integers    ${productList.json()}[total]    2
   ```

3. เรียกดูข้อมูลสินค้า

   ```robot
   &{ACCEPT}=    Create Dictionary    Accept=application/json
   ${product}=    GET On Session    toy_shop    api/v1/product/2    expected_status=200    headers=&{ACCEPT}
   Should Be Equal    ${product.json()}[product_name]    43 Piece dinner Set
   ```

4. ออเดอร์สินค้า

   ```robot
   &{CONTENT}=    Create Dictionary    Content-Type=application/json
   ${order}=    POST On Session    toy_shop    api/v1/order    expected_status=200    headers=&{CONTENT}    json=&{ORDER_TEMPLATE}
   Should Be Equal As Strings    ${order.json()}[order_id]    8004359122
   Should Be Equal As Numbers    ${order.json()}[total_price]    14.95
   ```

5. คอนเฟิร์มสินค้า

   ```robot
   &{POST_HEADERS}=      Create Dictionary     &{ACCEPT}    &{CONTENT}
   Set To Dictionary    ${CONFIRM_PAYMENT_TEMPLATE}    order_id=${order.json()}[order_id]
   ${paymentStatus}=    POST On Session    toy_shop    api/v1/confirmPayment    expected_status=200    headers=&{POST_HEADERS}    json=${CONFIRM_PAYMENT_TEMPLATE}
   Should Be Equal As Strings    ${paymentStatus.json()}[notify_message]    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
   ```
