*** Settings ***
Library    RequestsLibrary

*** Test Cases ***
Shopping Cart
    Create Session    toy_shop    https://dminer.in.th 
    ${productList}=    GET On Session    toy_shop    api/v1/product
    Status Should Be    200    ${productList}