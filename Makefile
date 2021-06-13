install:
	docker build -t udpipe1 -f Dockerfile-udpipe-1 .

start:
	docker run -v ~/Downloads/udpipe/1:/models \
	    -p 9090:8080 \
	    -e MODEL_FILE_NAME=english-ewt-ud-2.5-191206.udpipe \
	    -e MODEL_NAME=english-ewt \
	    -it udpipe1

test:
	#curl "http://localhost:9090/process?tokenizer&tagger&parser&data=He%20died%20yesterday." | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"
	curl -X POST -F "data=@tests/fixtures/input_eurostar.txt" -F "tokenizer=" -F "tagger=" -F "parser=" "http://localhost:9090/process" | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"

docker-test:
	docker-compose -f docker-compose-test.yml up
