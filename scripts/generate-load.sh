export SLEEP=0
export HOST=$(oc get route sample-rest-api -n island-ci-cd-poc -o jsonpath='{.spec.host}')
echo $HOST


curl -X 'GET' "https://${HOST}/hello" -H "accept: application/json"
echo ""
while true
do
  echo ""
  curl -X 'GET' "https://${HOST}/hello" -H "accept: application/json"
  sleep $SLEEP
done