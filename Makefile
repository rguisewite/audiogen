
default: sdist

sdist:
	python3 setup.py sdist

docs: README.html

README.html: README.rst
	pandoc $^ > $@

register: checkmetadata
	python3 setup.py register

upload: checkmetadata
	python3 setup.py sdist --sign
	python3 -m twine upload dist/*

checkmetadata:
	python3 setup.py check -s --restructuredtext

clean:
	find . -type f -name '*.pyc' -print0 | xargs -0 rm -f -- 
	rm -rf *.egg-info
	rm -f README.html
	rm -rf dist/
