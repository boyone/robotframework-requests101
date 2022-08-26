*** Settings ***
Library    RequestsLibrary

*** Test Cases ***
Shopping Cart
    Create Session    toy_shop    https://dminer.in.th 
    ${productList}=    GET On Session    toy_shop    api/v1/product    expected_status=200
    Should Be Equal As Integers    ${productList.json()}[total]    2

    &{ACCEPT}=    Create Dictionary    Accept=application/json
    ${product}=    GET On Session    toy_shop    api/v1/product/2    expected_status=200    headers=&{ACCEPT}