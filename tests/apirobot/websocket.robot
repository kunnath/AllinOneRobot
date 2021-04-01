*** Settings ***

Library          Process
Library          OperatingSystem
Library          Collections
Library          RequestsLibrary
Library          WebSocketClient
Library          String
Library          HttpLibrary.HTTP
Library          JSONLibrary
Force Tags       api
Variables        env.dev.yaml

*** Variables ***
${myws}       wss://api.staging.neontrading.com   
${my_websocket}
${exprep}      [{"slug":"LSX","active":true,"nameAtExchange":"APPLE COMPUTER INC.","symbolAtExchange":"APC","firstSeen":1547472665909,"lastSeen":1615953916762,"firstTradingDay":null,"lastTradingDay":null,"tradingTimes":null,"fractionalTrading":null}]
${node}          exchanges
*** Test Cases ***

Connect to wss and validate ticker and instrument from DE device
    &{sslopt}=  Create Dictionary  cert_reqs  ${0}         
    ${my_websocket}=  WebSocketClient.Connect  ${myws}  sslopt=${sslopt}  
    Log To Console      ${my_websocket}
    Log To Console        ${myws}
    WebSocketClient.Send     ${my_websocket}      connect 21
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    Log To Console      "***verifywebsocketconnection***"
    ${lines}=    Get Lines Matching Pattern    ${result}  connected
 # Validation steps   
    Run Keyword If   '${lines}' == ""        Run Keyword And Continue On Failure   FAIL    
    Log To Console      ${result}
#   Retrieve  ticker response
    WebSocketClient.Send     ${my_websocket}      sub 13 {"type":"ticker","id":"DE000BASF111.LSX"}
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    ${passed}=     String.Get Lines Containing String      ${result}   13 A	
    Run Keyword If   '${passed}' == ""        Run Keyword And Continue On Failure   FAIL      
    Log To Console      "***DE000BASF111.LSX**ticker***"
    Log To Console     ${result}
#   Retrieve  instrument response
    WebSocketClient.Send     ${my_websocket}      sub 1 {"type":"instrument","id":"DE000BASF111"}
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    ${passed}=     String.Get Lines Containing String      ${result}   1 A	
# Validation steps   
    Run Keyword If   '${passed}' == ""        Run Keyword And Continue On Failure   FAIL  
    Log To Console      "***DE000BASF111.LSX**ticker***"
    Log To Console       ${result}

Connect to wss and validate ticker and instrument from US device
#   Retrieve single instrument response
    &{sslopt}=  Create Dictionary  cert_reqs  ${1}         
    ${my_websocket}=  WebSocketClient.Connect  ${myws}  sslopt=${sslopt}  
    WebSocketClient.Send     ${my_websocket}      connect 21
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    Log To Console      "***DE000BASF111***instrument***"
#   Retrieve  instrument response
    WebSocketClient.Send     ${my_websocket}       sub 1 { "type": "instrument", "id": "US0378331005" }
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    Log To Console      "***verifywebsocketinstrument***"
    ${passed}=    String.Get Lines Containing String      ${result}  1 A   
# Validation steps 
    Run Keyword If   '${passed}' == ""        Run Keyword And Continue On Failure   FAIL     
    Log To Console       ${result}
#   Retrieve  ticker response
    Log To Console      "***DE000BASF111.LSX**ticker***"
    WebSocketClient.Send     ${my_websocket}      sub 13 {"type":"ticker","id":"US0378331005"}
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    ${passed}=    String.Get Lines Containing String      ${result}  13 E
    Run Keyword If   '${passed}' == ""        Run Keyword And Continue On Failure   FAIL  
    Log To Console        ${result}
#   Retrieve single instrument response
    Log To Console      "***DE000BASF111***instrument***"
    WebSocketClient.Send     ${my_websocket}       sub 13 { "type": "instrument", "id": "US0378331005" }
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    Log To Console      "***verifywebsocketinstrument***"
    ${passed}=    String.Get Lines Containing String    ${result}  13 A 
# Validation steps 
    Run Keyword If   '${passed}' == ""        Run Keyword And Continue On Failure   FAIL  
    Log To Console       ${result}

Connect to wss and validate instrument and device udid response
    &{sslopt}=  Create Dictionary  cert_reqs  ${2}         
    ${my_websocket}=  WebSocketClient.Connect  ${myws}  sslopt=${sslopt}  
#   device id response
    Log To Console   "***deviceudidconnect***"
    WebSocketClient.Send     ${my_websocket}      connect 21 {"device": "FDF93099-8A6B-4C95-AC5C-463937AFF51D","clientId": "cta", "clientVersion": "1.0.1","platformId": "ios","platformVersion": "10.2","locale": "de"}
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    Log To Console    "verifyconnection"
    ${lines}=    Get Lines Matching Pattern    ${result}  connected
# Validation steps 
    Run Keyword If   '${lines}' == ""        Run Keyword And Continue On Failure   FAIL  
    Log To Console        ${lines}


connect to wss and validate exchanges node 
    &{sslopt}=  Create Dictionary  cert_reqs  ${1}         
    ${my_websocket}=  WebSocketClient.Connect  ${myws}  sslopt=${sslopt}  
#   device id response
    Log To Console   "***deviceudidconnect***"
    WebSocketClient.Send     ${my_websocket}      connect 21 
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    ${lines}=    Get Lines Matching Pattern    ${result}  connected
#    Validation steps 
    Run Keyword If   '${lines}' == ""        Run Keyword And Continue On Failure   FAIL  
    WebSocketClient.Send     ${my_websocket}       sub 13 { "type": "instrument", "id": "US0378331005" }
    ${result}=     WebSocketClient.Recv     ${my_websocket}
    # ${result}=     Convert String to JSON   ${result1}  
    ${post}=	Split String	${result}	{
    log    ${result}
    log    ${post[2]}
    ${our_json}=   Convert String to JSON    ${exprep}  
    log    ${our_json}
    # Run keyword And Continue On Failure    Fail
    Json packet analyser  ${result}  exchanges   ${exprep}



*** Keywords *** 
Json packet analyser 
      [Documentation]  Find a given JSON packet in an array of packets embedded within a JSON object 
      [Arguments]  ${our_json}  ${json_pointer}  ${expected_json_packet} 
      ${parsed}=  Convert String to JSON  ${our_json} 
      ${length}=  get length  ${parsed["${json_pointer}"]} 
        : FOR    ${out_json}    IN RANGE  0   ${length}
        \    ${id_value_pair}=  Get Value From Json   ${parsed}     $..${json_pointer}[${out_json}]  
        \    ${status}=  Run Keyword And Return Status  Should Be Equal As Strings  ${id_value_pair}  ${expected_json_packet} 
        \    Exit For Loop IF  ${status}  
      Should Be Equal As Strings  ${id_value_pair}  ${expected_json_packet} 