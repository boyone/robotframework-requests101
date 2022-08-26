*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
&{ACCEPT}               Accept=application/json
&{CONTENT}              Content-Type=application/json

&{CART}                 product_id=2    quantity=1

@{CARTS}                &{CART}

&{ORDER_TEMPLATE}       cart=@{CARTS}    shipping_method=Kerry    
...                     shipping_address=405/37 ถ.มหิดล    
...                     shipping_sub_district=ท่าศาลา    
...                     shipping_district=เมือง    
...                     shipping_province=เชียงใหม่     
...                     shipping_zip_code=50000    
...                     recipient_name=ณัฐญา ชุติบุตร     
...                     recipient_phone_number=0970809292

&{CONFIRM_PAYMENT_TEMPLATE}     payment_type=credit    
...                             type=visa    
...                             card_number=4719700591590995    
...                             cvv=752    
...                             expired_month=7    
...                             expired_year=20    
...                             card_name=Karnwat Wongudom    
...                             total_price=14.95

*** Test Cases ***
Shopping Cart
    สร้าง Session
    เรียกดูสินค้าทั้งหมด
    เรียกดูข้อมูลสินค้า
    ออเดอร์สินค้า
    คอนเฟิร์มสินค้า

*** Keywords ***
สร้าง Session
    Create Session    toy_shop    https://dminer.in.th 

เรียกดูสินค้าทั้งหมด
    ${productList}=    GET On Session    toy_shop    api/v1/product    expected_status=200
    Should Be Equal As Integers    ${productList.json()}[total]    2

เรียกดูข้อมูลสินค้า
    ${product}=    GET On Session    toy_shop    api/v1/product/2    expected_status=200    headers=&{ACCEPT}
    Should Be Equal    ${product.json()}[product_name]    43 Piece dinner Set

ออเดอร์สินค้า
    ${order}=    POST On Session    toy_shop    api/v1/order    expected_status=200    headers=&{CONTENT}    json=&{ORDER_TEMPLATE}
    Should Be Equal As Strings    ${order.json()}[order_id]    8004359122
    Should Be Equal As Numbers    ${order.json()}[total_price]    14.95
    Set Test Variable    ${order_id}    ${order.json()["order_id"]}

คอนเฟิร์มสินค้า
    &{POST_HEADERS}=      Create Dictionary     &{ACCEPT}    &{CONTENT}
    Set To Dictionary    ${CONFIRM_PAYMENT_TEMPLATE}    order_id=${order_id}
    ${paymentStatus}=    POST On Session    toy_shop    api/v1/confirmPayment    expected_status=200    headers=&{POST_HEADERS}    json=${CONFIRM_PAYMENT_TEMPLATE}
    Should Be Equal As Strings    ${paymentStatus.json()}[notify_message]    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900