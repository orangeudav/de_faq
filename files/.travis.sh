#!/bin/bash

DIR=`dirname $0`
EXIT_CODE=0

go build -o $DIR/spell-checker $DIR/spell-checker.go
exit
git diff HEAD^ --name-only > changed_files

while read FILE; do
    echo -n "Проверка файла $FILE на опечатки... ";

    OUTPUT_RU=$(cat "$FILE" | hunspell -d ru_RU | $DIR/spell-checker);
    RU_EXIT_CODE=$?
    OUTPUT_EN=$(cat "$FILE" | hunspell -d en_US | $DIR/spell-checker);
    EN_EXIT_CODE=$?

    if [ $RU_EXIT_CODE -ne 0 ] || [ $EN_EXIT_CODE -ne 0 ]; then
        EXIT_CODE=1;
        echo "ошибка";
        echo "$OUTPUT_RU\n$OUTPUT_EN" | sort -n -k1,4;
    else
        echo "пройдена";
    fi
done < changed_files

exit $EXIT_CODE