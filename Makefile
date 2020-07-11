VERSION := $(file < version)
MACOS := go-test-report-darwin-$(VERSION)
LINUX := go-test-report-linux-$(VERSION)
WINDOWS := go-test-report-windows-$(VERSION)


genbuild: gencode
	go build

gencode:
	(cd embed_assets/;set -e;go build;./embed_assets)

buildall: genbuild
	echo "Building..."

	mkdir -p release_builds/linux-amd64/
	mkdir -p release_builds/darwin-amd64/
	mkdir -p release_builds/windows-amd64/

	echo "Linux 64bit"
	GOOS=linux GOARCH=amd64 go build -o release_builds/linux-amd64/
	(cd release_builds/linux-amd64/; tar -czf $(LINUX).tgz go-test-report)
	(cd release_builds/linux-amd64/; shasum -a 256 go-test-report |  cut -d ' ' -f 1 > $(LINUX).sha)


	echo "Darwin (MacOS) 64bit"
	GOOS=darwin GOARCH=amd64 go build -o release_builds/darwin-amd64/
	(cd release_builds/darwin-amd64/; tar -czf $(MACOS).tgz go-test-report)
	(cd release_builds/darwin-amd64/; shasum -a 256 go-test-report |  cut -d ' ' -f 1 > $(MACOS).sha)

	echo "Windows 64bit"
	GOOS=windows GOARCH=amd64 go build -o release_builds/windows-amd64/
	(cd release_builds/windows-amd64/; zip -r $(WINDOWS).zip go-test-report.exe)
	(cd release_builds/windows-amd64/; shasum -a 256 go-test-report |  cut -d ' ' -f 1 > $(WINDOWS).sha)

	echo "...Done!"
