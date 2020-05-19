#!/bin/bash

appName="rancher"
appDomain="hm.loc"

# {--uninstall, --upgrade, --install}
appOps=$1
nameSpace="cattle-system"
chartName="${appName}"

kubectl config use-context hm01-dev

case ${appOps} in
    
    --install)
        
		    echo "Install Helm Chart ${chartName}"

        helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
	  		
				kubectl create namespace ${nameSpace} 
        
        kubectl create secret tls tls-rancher-ingress \
            --namespace ${nameSpace} \
            --key=certificates/tls.key \
            --cert=certificates/tls.cert

        kubectl create secret generic tls-ca \
	  		    --namespace ${nameSpace} \
            --from-file=certificates/cacerts.pem
				
				helm install --debug --create-namespace rancher rancher-latest/rancher \
					  --namespace ${nameSpace} \
					  --set hostname=${appName}.${appDomain} \
            --set privateCA=true \
            --set replicas=1 \
            --set ingress.tls.source=secret	
				
				;;
		
    --upgrade)
 				
		    echo "Upgrade Helm chart ${chartName}"
				
        helm upgrade --install --debug --create-namespace rancher rancher-latest/rancher \
					  --namespace ${nameSpace} \
				  	--set hostname=${appName}.${appDomain} \
            --set privateCA=true \
            --set replicas=1 \
				  	--set ingress.tls.source=secret	
				;;
    
    --uninstall)
			  
				echo "Deletin Helm Chart ${chartName}"
			  
			  helm uninstall ${chartName} --namespace=${nameSpace}
			
				#kubectl delete namespace ${nameSpace} 
        #kubectl get namespace cattle-system -o json > logging.json
        #kubectl replace --raw "/api/v1/namespaces/cattle-system/finalize" -f ./logging.json

        ;; 

    --debug)
			  
				echo "Debug Helm Chart ${chartName}"
			  
        kubectl -n ${nameSpace} get deploy ${chartName}
			
        ;; 
        
    *)
				echo "Set requirements !"
        ;;
esac

