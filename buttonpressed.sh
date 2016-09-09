#!/bin/bash
OUT_DIR=/home/me/scan
TMP_DIR=`mktemp -d`
FILE_NAME=`date +%Y_%m_%d_%H_%M_%S`

pushd $TMP_DIR
echo "################## Scanning ###################"
if scanimage --resolution 150 --batch=scan_%03d.pnm --format=pnm --mode Gray --device-name "epjitsu:libusb:001:108" --source "ADF Duplex" --page-width 210 --page-height 297 ; then
	echo "################## Cleaning ###################"
	for f in ./*.pnm; do
	   unpaper –size a4 –overwrite "$f" "$f"
	done
	echo "############## Converting to PDF ##############"
	mogrify -format tif *.pnm
	echo "################ Cleaning Up & OCR ################"

	for f in ./*.tif; do
	   tesseract "$f" "$f" -l eng hocr
	   xsltproc -html -nonet -novalid -o "$f.hocr_fixed" /home/me/fix-hocr.xsl "$f.hocr"
	   hocr2pdf -i "$f" -o "$f.pdf" < "$f.hocr_fixed"
	done
	pdftk *.tif.pdf cat output $FILE_NAME.pdf
	chown me:me $FILE_NAME.pdf
	cp -a $FILE_NAME.pdf $OUT_DIR/
fi
rm -r $TMP_DIR
echo "################ Done! ################"
popd

