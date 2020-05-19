#!/bin/bash

appName="nginx-ingress-controller"

# {--install, --uninstall, --upgrade}
appOps=$1
nameSpace="${appName}"
chartName="${appName}"
secretTlsName="global-tls"

kubectl config use-context hm01-dev


case ${appOps} in
    
    --install)
		
        echo "Install Helm Chart ${chartName}"

        kubectl create secret tls ${secretTlsName} \
            --namespace ${nameSpace} \
            --key  ~/Documents/home/automation/scripts/certificate/certs/global/global.key \
            --cert ~/Documents/home/automation/scripts/certificate/certs/global/global.crt
  
        helm upgrade --install --debug --create-namespace --namespace ${nameSpace} ${chartName} bitnami/${appName} \
            --set hostNetwork="true" \
            --set dnsPolicy="ClusterFirstWithHostNet" \
            --set kind="Deployment" \
            --set nodeSelector.ingress="allow" \
            --set replicaCount=1 \
            --set defaultBackend.nodeSelector.ingress="allow" \
            --set defaultBackend.replicaCount=1 \
            --set metrics.enabled="true" \
            --set extraArgs.default-ssl-certificate="${nameSpace}/${secretTlsName}"
				;;
    
    --upgrade)
				
        echo "Upgrade Helm chart ${chartName}"
        
        helm upgrade --install --debug --create-namespace --namespace ${nameSpace} ${chartName} bitnami/${appName} \
            --set hostNetwork="true" \
            --set dnsPolicy="ClusterFirstWithHostNet" \
            --set kind="Deployment" \
            --set nodeSelector.ingress="allow" \
            --set replicaCount=1 \
            --set defaultBackend.nodeSelector.ingress="allow" \
            --set defaultBackend.replicaCount=1 \
            --set metrics.enabled="true" \
            --set extraArgs.default-ssl-certificate="${nameSpace}/${secretTlsName}"
				;;
    
    --uninstall)
			  
				echo "Delete Helm Chart ${chartName}"
			  
			  helm uninstall ${chartName} --namespace=${nameSpace}
			
        ;; 

    --debug)
			  
				echo "Debug Helm Chart ${chartName}"
			  
        kubectl -n ${nameSpace} get deploy ${chartName}
			
        ;; 

        
    *)
				echo "Set requirements !"
        ;;
esac
