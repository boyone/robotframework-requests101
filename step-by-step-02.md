# Extract Keywords Step by Step: Step 2

- [Step #1 : แบ่งกลุ่มการทำงาน](./step-by-step-01.md)
- [Step #2 : สร้าง keyword ของการสร้าง Session](./step-by-step-02.md)
- [Step #3 : สร้าง keyword ของการเรียกดูสินค้าทั้งหมด](./step-by-step-03.md)
- [Step #4 : สร้าง keyword ของการเรียกดูข้อมูลสินค้า](./step-by-step-04.md)
- [Step #5 : สร้าง keyword ของการออเดอร์สินค้า](./step-by-step-05.md)
- [Step #6 : สร้าง keyword ของการคอนเฟิร์มสินค้า](./step-by-step-06.md)

## สร้าง keyword ของการสร้าง Session

1. สร้าง User Keywords โดยพิมพ์ `*** Keywords ***` ไว้บรรทัดล่างสุด ของไฟล์

   ```robot
   ...
      Should Be Equal As Strings    ${paymentStatus.json()}[notify_message]    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900

   *** Keywords ***
   ```

2. ตั้งชื่อ Keyword ว่า `สร้าง Session`

   ```robot
   *** Keywords ***
   สร้าง Session
   ```

3. Copy `Create Session ...` ไปวางไว้ใต้ Keywords ที่ทำไว้ใน Step ที่ 2

   ```robot
   *** Keywords ***
   สร้าง Session
      Create Session    toy_shop    https://dminer.in.th
   ```

4. แทนที่ `Create Session ...` ด้วย `สร้าง Session`

   ```robot
   *** Test Cases ***
   Shopping Cart
      สร้าง Session
   ```

5. ทดสอบ

   ```sh
   robot shopping-cart.robot
   ```
