echo 'Querying...'
for i in `seq 1 1000`; do
    curl -H "Content-Type: application/json" -X POST -d '"15 7 1 1 + - / 3 * 2 1 1 + + -"' -s localhost:3000/evaluate > /dev/null
done
echo 'Done'
