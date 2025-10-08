
#!/bin/bash
set -e

# Step 2: Wait for external hostname
while true
do
  echo -n "Killercoda service URL exposed to the Internet:  "
  read HOST
  if [[ -n "$HOST" ]]
  then
    echo "Backend hostname: $HOST"
    break
  fi
done

# Step 3: Deploy frontend reverse proxy
export BACKEND_HOST=$HOST
envsubst '$BACKEND_HOST' < nginx-cdn-template.yaml | kubectl apply -f -
echo "Reverse proxy deployed pointing to $BACKEND_HOST"

sleep 7
kubectl get pod
kubectl get svc
