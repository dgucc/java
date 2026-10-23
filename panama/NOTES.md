curl --silent -X GET -L http://localhost:8080/api/v1/stk/0444745790 | jq > sample.csv
awk -F',' 'BEGIN{OFS=","} {print $7,$8,$1,$2,$4}' src/main/resources/sample.csv


curl --silent -X GET -L http://localhost:8080/api/v1/stk/0695982819 | jq > sample.csv
awk -F',' 'BEGIN{OFS=","} {print $7,$8,$1,$2,$4}' src/main/resources/sample.csv


curl --silent -X GET -L http://localhost:8080/api/v1/stk/0444745790 | jq -r ' .[] | [.parentBce, .parentName, .childBce, .childName, .direct] | @csv'

curl --silent -X GET -L http://localhost:8080/api/v1/stk/0444745790 | jq -r ' .[] | [.parentBce, .parentName, .childBce, (.childName + " [" + .country + "]"), .direct] | @csv'
"0462955066     ","Braem Invest","0871057129     ","Immo West-Vlaanderen NV [BE]",50.0000
"0462955066     ","Braem Invest","0444745790     ","MAN Brugge NV [BE]",50.0000
"0462955066     ","Braem Invest","0433913563     ","Imbraco NV [BE]",73.6600
"0462955066     ","Braem Invest","0734443616     ","Van & Truck Rental [BE]",74.9000
"0462955066     ","Braem Invest","0433912375     ","Braem NV [BE]",74.9700
"0462955066     ","Braem Invest","0871058416     ","Man West-Vlaanderen NV [BE]",50.0000
"0462955066     ","Braem Invest","0838724950     ","TSE Truck Service Europe NV [BE]",74.9000


curl --silent -X GET -L http://localhost:8080/api/v1/stk/0695982819 | jq -r ' .[] | [.parentBce, .parentName, .childBce, (.childName + " [" + .country + "]"), .direct] | @csv' | sed 's/{2,}"/ /g' 
