#!/bin/bash
TESSERACT_OCR_VERSION=3.03
TESSERACT_OCR_DATA_VERSION=3.02
TESSERACT_OCR_TGZ=tesseract-ocr-$TESSERACT_OCR_VERSION.tar.gz
INSTALL_DIR=$BUILD_DIR/vendor/tesseract-ocr/
INSTALL_DIR_TRAINING_DATA=$BUILD_DIR/vendor/
TESSERACT_OCR_DIR=${HOME}/vendor/tesseract-ocr
ENVSCRIPT=$BUILD_DIR/.profile.d/tesseract-ocr.sh
TESSERACT_OCR_LANGUAGES=eng,jpn

echo "       - Unpacking Tesseract-OCR binaries"
mkdir -p $INSTALL_DIR
tar -zxvf $TESSERACT_OCR_TGZ -C $INSTALL_DIR
cp -rp tessdata $INSTALL_DIR

echo "       - Building Languegedata for Tesseract-OCR"
if [ $TESSERACT_OCR_LANGUAGES ]
then
   array=(${TESSERACT_OCR_LANGUAGES//,/ })
   for i in "${!array[@]}"
   do
     lang="${array[i]}"
     echo $lang 'training data'
     curl https://tesseract-ocr.googlecode.com/files/tesseract-ocr-$TESSERACT_OCR_DATA_VERSION.$lang.tar.gz -o - | tar -xz -C $INSTALL_DIR_TRAINING_DATA -f -
     echo "https://tesseract-ocr.googlecode.com/files/tesseract-ocr$TESSERACT_OCR_DATA_VERSION.$lang.tar.gz"
   done
fi

ls -al tessdata
#cp -rp tessdata $TESSERACT_OCR_DIR
#mkdir $TESSERACT_OCR_DIR/tessdata
mv tessdata/* INSTALL_DIR_TRAINING_DATA
ls -al tessdata
echo "       - Building runtime environment for Tesseract-OCR"
mkdir -p $BUILD_DIR/.profile.d
echo "export PATH=\"$TESSERACT_OCR_DIR/bin:\$PATH\"" > $ENVSCRIPT
echo "export LD_LIBRARY_PATH=\"$TESSERACT_OCR_DIR/lib:\$LD_LIBRARY_PATH\"" >> $ENVSCRIPT
echo "export TESSDATA_PREFIX=\"$TESSERACT_OCR_DIR/\"" >> $ENVSCRIPT
echo "       Done"