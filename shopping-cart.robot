*** Settings ***
Library    RequestsLibrary

*** Variables ***
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

*** Test Cases ***
Shopping Cart
    Create Session    toy_shop    https://dminer.in.th 
    ${productList}=    GET On Session    toy_shop    api/v1/product    expected_status=200
    Should Be Equal As Integers    ${productList.json()}[total]    2

    &{ACCEPT}=    Create Dictionary    Accept=application/json
    ${product}=    GET On Session    toy_shop    api/v1/product/2    expected_status=200    headers=&{ACCEPT}
    Should Be Equal    ${product.json()}[product_name]    43 Piece dinner Set

    &{CONTENT}=    Create Dictionary    Content-Type=application/json
    ${product}=    POST On Session    toy_shop    api/v1/order    expected_status=200    headers=&{CONTENT}    data=&{ORDER_TEMPLATE}