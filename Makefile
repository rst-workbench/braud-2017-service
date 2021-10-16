docker-build:
	docker build -t udpipe1 -f Dockerfile-udpipe-1 .

docker-run-en:
	docker run -v ~/repos/braud-2017-service/udpipe-models:/models \
	    -p 9001:9001 \
	    -e DEFAULT_MODEL=english-ewt \
	    -it udpipe1

docker-run-de:
	docker run -v ~/repos/braud-2017-service/udpipe-models:/models \
	    -p 9001:9001 \
	    -e DEFAULT_MODEL=german-hdt \
	    -it udpipe1

test:
	curl -X POST -F "data=@tests/fixtures/input_eurostar_en.txt" -F "tokenizer=" -F "tagger=" -F "parser=" "http://localhost:9001/process" | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"

docker-test:
	docker-compose -f docker-compose-test.yml up --build --exit-code-from braud-2017-service
