docker-build:
	docker build -t udpipe1 -f Dockerfile-udpipe-1 .

docker-run:
	docker run -v ~/repos/braud-2017-service/udpipe-models:/models \
	    -p 9001:9001 \
	    -e MODEL_FILE_NAME=english-ewt-ud-2.5-191206.udpipe \
	    -e MODEL_NAME=english-ewt \
	    -it udpipe1

test:
	#curl "http://localhost:9001/process?tokenizer&tagger&parser&data=He%20died%20yesterday." | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"
	curl -X POST -F "data=@tests/fixtures/input_eurostar_en.txt" -F "tokenizer=" -F "tagger=" -F "parser=" "http://localhost:9001/process" | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"

docker-test:
	docker-compose -f docker-compose-test.yml up --build --exit-code-from braud-2017-service
