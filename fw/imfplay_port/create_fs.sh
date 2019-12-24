MKSPIFFS=../../../mkspiffs/mkspiffs
PREBUILT=../../prebuilt

${MKSPIFFS}  -c opl3dro -b 131072 -p 256 -s 7733248 ${PREBUILT}/dro_test_spiffs.img
${MKSPIFFS}  -c opl3dro -b 65536 -p 256 -s 3276800 ${PREBUILT}/dro_test_spiffs-g2-c.img


