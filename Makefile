APP_NAME = kotlin-app
BASE_DIR = $(shell pwd)/app
DOCKER_IMAGE = $(APP_NAME):latest
DOCKER_CONTAINER = $(APP_NAME)-container
KIND_CLUSTER=itau-cluster
PORT = 8080
#export JAVA_HOME=$(/usr/libexec/java_home -v 17) && export PATH=$JAVA_HOME/bin:$PATH

build:
	cd $(BASE_DIR) && ./gradlew clean build -x test

docker-build:
	cd $(BASE_DIR) && docker build --no-cache -t $(DOCKER_IMAGE) .

docker-run: docker-build
	docker run --rm -p $(PORT):8080 --name $(DOCKER_CONTAINER) $(DOCKER_IMAGE)

docker-scan:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image $(DOCKER_IMAGE)

docker-clean:
	docker rmi -f $(DOCKER_IMAGE)

kind-create-cluster:
	kind create cluster --name $(KIND_CLUSTER)

kind-load-image:
	kind load docker-image $(DOCKER_IMAGE) --name $(KIND_CLUSTER)

kind-delete-cluster:
	kind delete cluster --name $(KIND_CLUSTER)

kind-export-app:
	kubectl port-forward service/$(APP_NAME) $(PORT):8080

helm-install:
	helm install $(APP_NAME) $(BASE_DIR)/../Chart/app

helm-uninstall:
	helm uninstall $(APP_NAME)

terraform-apply:
	cd $(BASE_DIR)/../terraform && terraform init && terraform apply -auto-approve

terraform-destroy:
	cd $(BASE_DIR)/../terraform && terraform destroy -auto-approve

istio-install:
	istioctl install --set profile=demo -y
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/kiali.yaml

istio-uninstall:
	kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/kiali.yaml
	istioctl x uninstall --purge -y
	kubectl delete namespace istio-system

prometheus-install:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace -f observability/prometheus-values.yaml

prometheus-uninstall:
	helm uninstall prometheus --namespace monitoring

prometheus-access:
	kubectl port-forward -n monitoring service/prometheus-server 9090:80
	@echo "Access Prometheus at http://localhost:9090"

grafana-install:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update
	helm install grafana grafana/grafana --namespace monitoring --create-namespace -f observability/grafana-values.yaml

grafana-uninstall:
	helm uninstall grafana --namespace monitoring

grafana-access:
	kubectl port-forward -n monitoring service/grafana 3000:80
	@echo "Access Grafana at http://localhost:3000 (username: admin, password: admin)"

clean:
	cd $(BASE_DIR) && ./gradlew clean

clean-all: clean docker-clean

all: build docker-build docker-run