# Extract Keywords Step by Step: Step 3

- [Step #1 : แบ่งกลุ่มการทำงาน](./step-by-step-01.md)
- [Step #2 : สร้าง keyword ของการสร้าง Session](./step-by-step-02.md)
- [Step #3 : สร้าง keyword ของการเรียกดูสินค้าทั้งหมด](./step-by-step-03.md)
- [Step #4 : สร้าง keyword ของการเรียกดูข้อมูลสินค้า](./step-by-step-04.md)
- [Step #5 : สร้าง keyword ของการออเดอร์สินค้า](./step-by-step-05.md)
- [Step #6 : สร้าง keyword ของการคอนเฟิร์มสินค้า](./step-by-step-06.md)

## สร้าง keyword ของการเรียกดูสินค้าทั้งหมด

1. ตั้งชื่อ Keyword ว่า `เรียกดูสินค้าทั้งหมด`

   ```robot
   *** Keywords ***
   สร้าง Session
   ...

   เรียกดูสินค้าทั้งหมด
   ```

2. Copy `${productList}= GET On Session ...` ไปวางไว้ใต้ Keywords ที่ทำไว้ใน Step ที่ 1

   ```robot
   *** Keywords ***
   สร้าง Session
   ...

   เรียกดูสินค้าทั้งหมด
      ${productList}=    GET On Session    toy_shop    api/v1/product    expected_status=200
      Should Be Equal As Integers    ${productList.json()}[total]    2
   ```

3. แทนที่ `${productList}= GET On Session ...` ด้วย `เรียกดูสินค้าทั้งหมด`

   ```robot
   *** Test Cases ***
   Shopping Cart
      สร้าง Session
      เรียกดูสินค้าทั้งหมด
   ```

4. ทดสอบ

   ```sh
   robot shopping-cart.robot
   ```
