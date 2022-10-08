CURRENT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

test:
	@echo $(CURRENT_DIR)

prometheus:
	docker run --name prometheus -p 9090:9090 \
	 -v $(CURRENT_DIR)/monitor/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus