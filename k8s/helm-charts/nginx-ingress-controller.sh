#!/bin/bash

appName="nginx-ingress-controller"

# {delete, upgrade}
appOps=$1

nameSpace="${appName}"
chartName="${appName}"

kubectl config use-context hm01-dev

# ---------- App OPS
if [[ "${appOps}" == "delete" ]]; then

  echo "Deletin Helm Chart ${chartName}"
  
  helm uninstall ${chartName} --namespace=${nameSpace}

elif [[ "${appOps}" == "upgrade" ]]; then

  helm upgrade --install --debug --create-namespace --namespace ${nameSpace} ${chartName} bitnami/${appName} \
    --set hostNetwork="true" \
    --set dnsPolicy="ClusterFirstWithHostNet" \
    --set kind="Deployment" \
    --set nodeSelector.ingress="allow" \
    --set defaultBackend.nodeSelector.ingress="allow" \
    --set metrics.enabled="true"

else
  echo "Set requirements !"
fi
