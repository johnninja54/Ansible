cmd=$(mkdir -p /home/tringuyen/.kube)
cmd=$(cp -i /home/script/config /home/tringuyen/.kube/config)
cmd=$(chmod 777 /home/tringuyen/.kube/config)
cmd=$(kubectl apply -f /home/script/testwebserver.yml)