#!/usr/bin/env bash
 
# testarchiver  --config /Users/sreelesh/Documents/Traderepublic/AutomationTradepublic/TestArchiver/test_config.json  --dont-require-ssl --team QA_Team --format robot /Users/sreelesh/Documents/Traderepublic/AutomationTradepublic/reports/output.xmlParsing: '/Users/sreelesh/Documents/Traderepublic/AutomationTradepublic/reports/output.xml'

 
testarchiver  --config $1  --dont-require-ssl --team QA_Team --format robot $2
