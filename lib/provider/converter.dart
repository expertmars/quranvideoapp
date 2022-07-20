Map<String, dynamic> mapTable = {
  "font": "karthika",
  "map": {
    "ം": "w",
    "ഃ": "x",
    "അ": "A",
    "ആ": "B",
    "ഇ": "C",
    "ഈ": "Cu",
    "ഉ": "D",
    "ഊ": "Du",
    "ഋ": "E",
    "ഌ": "p",
    "എ": "F",
    "ഏ": "G",
    "ഐ": "sF",
    "ഒ": "H",
    "ഓ": "Hm",
    "ഔ": "Hu",
    "ക": "I",
    "ഖ": "J",
    "ഗ": "K",
    "ഘ": "L",
    "ങ": "M",
    "ച": "N",
    "ഛ": "O",
    "ജ": "P",
    "ഝ": "Q",
    "ഞ": "R",
    "ട": "S",
    "ഠ": "T",
    "ഡ": "U",
    "ഢ": "V",
    "ണ": "W",
    "ത": "X",
    "ഥ": "Y",
    "ദ": "Z",
    "ധ": "[",
    "ന": "\\",
    "പ": "]",
    "ഫ": "^",
    "ബ": "_",
    "ഭ": "`",
    "മ": "a",
    "യ": "b",
    "ര": "c",
    "റ": "d",
    "ല": "e",
    "ള": "f",
    "ഴ": "g",
    "വ": "h",
    "ശ": "i",
    "ഷ": "j",
    "സ": "k",
    "ഹ": "l",
    "ാ": "m",
    "ി": "n",
    "ീ": "o",
    "ു": "p",
    "ൂ": "q",
    "ൃ": "r",
    "െ": "s",
    "േ": "t",
    "ൈ": "ss",
    "ൊ": "sm",
    "ോ": "tm",
    "ൌ": "su",
    "്‌": "v",
    "്": "v",
    "ൗ": "u",
    "്യേ": "ty",
    "്യെ": "sy",
    "ക്ക": "¡",
    "ക്ല": "¢",
    "ക്ഷ": "£",
    "ഗ്ഗ": "¤",
    "ഗ്ല": "¥",
    "ങ്ക": "¦",
    "ങ്ങ": "§",
    "ച്ച": "¨",
    "ഞ്ച": "©",
    "ഞ്ഞ": "ª",
    "ട്ട": "«",
    "ണ്‍": "¬",
    "ണ്ട": "ï",
    "ണ്ണ": "®",
    "ത്ത": "¯",
    "ത്ഥ": "°",
    "ദ്ദ": "±",
    "ദ്ധ": "²",
    "ന്‍": "³",
    "ൻ": "³",
    "ന്ത": "´",
    "ന്ദ": "µ",
    "ന്ന": "¶",
    "ന്മ": "·",
    "പ്പ": "¸",
    "പ്ല": "¹",
    "ബ്ബ": "º",
    "ബ്ല": "»",
    "മ്പ": "¼",
    "മ്മ": "½",
    "മ്ല": "Ÿ",
    "യ്യ": "¿",
    "ർ‌": "À",
    "ർ‍": "À",
    "ർ": "À",
    "ര്‍": "À",
    "റ്റ": "ä",
    "ല്‍": "Â",
    "ൽ": "Â",
    "ല്ല": "Ã",
    "ള്‍": "Ä",
    "ൾ": "Ä",
    "ള്ള": "Å",
    "വ്വ": "Æ",
    "ശ്ല": "Ç",
    "ശ്ശ": "È",
    "സ്ല": "É",
    "സ്സ": "Ê",
    "ഹ്ല": "Ë",
    "സ്റ്റ": "Ì",
    "ഡ്ഡ": "Í",
    "ക്ട": "Î",
    "ബ്ധ": "Ï",
    "ബ്ദ": "Ð",
    "ച്ഛ": "Ñ",
    "ഹ്മ": "Ò",
    "ഹ്ന": "Ó",
    "ന്ധ": "Ô",
    "ത്സ": "Õ",
    "ജ്ജ": "Ö",
    "ണ്മ": "×",
    "സ്ഥ": "Ø",
    "ന്ഥ": "Ù",
    "ജ്ഞ": "Ú",
    "ത്ഭ": "Û",
    "ഗ്മ": "Ü",
    "ശ്ച": "Ý",
    "ണ്ഡ": "Þ",
    "ത്മ": "ß",
    "ക്ത": "à",
    "ഗ്ന": "á",
    "ന്റ": "â",
    "ഷ്ട": "ã",
    "്യ": "y",
    "്വ": "z",
    "്ര": "{",
    "-": "þ"
  }
};

unicode2ascii(String strText, map) {
  //alert(strText);
  var chUnicode;
  var chAscii;
  var index;
  var lenChar;
  var bRepham = 0;
  var ascii_text = "";

  //mapTable=JSON.parse(karthikaJson);
  //alert(mapTable.map["ണ്ട"]);
  for (index = 0; index < strText.length;) {
    for (lenChar = 3; lenChar > 0; lenChar--) {
      chUnicode = strText.substring(index, index + lenChar);
      //alert (chUnicode);
      if (mapTable['map'][chUnicode]) {
        chAscii = mapTable['map'][chUnicode];
        if (chUnicode == "ൈ") {
          if (bRepham == 1) {
            bRepham = 0;
            ascii_text = ascii_text.substring(0, ascii_text.length - 2) +
                chAscii +
                ascii_text[ascii_text.length - 2] +
                ascii_text[ascii_text.length - 1];
          } else {
            ascii_text = ascii_text.substring(0, ascii_text.length - 1) +
                chAscii +
                ascii_text[ascii_text.length - 1];
          }
        } else if ((chUnicode == "ോ") ||
            (chUnicode == "ൊ") ||
            (chUnicode == "ൌ")) {
          if (bRepham == 1) {
            bRepham = 0;
            ascii_text = ascii_text.substring(0, ascii_text.length - 2) +
                chAscii[0] +
                ascii_text[ascii_text.length - 2] +
                ascii_text[ascii_text.length - 1] +
                chAscii[1];
          } else {
            //alert (chUnicode);
            //alert ("char0:"+chAscii[0]+" middlechar:"+ascii_text[ascii_text.length-1]+ " char1:"+chAscii[1]);
            ascii_text = ascii_text.substring(0, ascii_text.length - 1) +
                chAscii[0] +
                ascii_text[ascii_text.length - 1] +
                chAscii[1];
            //alert ("ascii_text(ഒ ഓ ഒ ഔ): "+ascii_text);
          }
        } else if (chUnicode == "്യേ" || chUnicode == "്യെ") {
          //alert (chUnicode);
          bRepham = 0;
          //alert ("starting char:"+ascii_text[ascii_text.length-2]+"char0:"+chAscii[0]+" middlechar:"+ascii_text[ascii_text.length-1]+ " char1:"+chAscii[1]);
          ascii_text = ascii_text.substring(0, ascii_text.length - 1) +
              chAscii[0] +
              ascii_text[ascii_text.length - 1] +
              chAscii[1];
          //alert ("ascii_text(യേ യെ): "+ascii_text);
        } else if ((chUnicode == "െ") ||
            (chUnicode == "േ") ||
            (chUnicode == "്ര")) {
          //alert (chUnicode);

          //alert(" middlechar:"+ascii_text[ascii_text.length-2]+ " char1:"+chAscii[1]);
          if (bRepham == 1) {
            ascii_text = ascii_text.substring(0, ascii_text.length - 2) +
                chAscii[0] +
                ascii_text[ascii_text.length - 2] +
                ascii_text[ascii_text.length - 1];
            bRepham = 0;
          } else {
            ascii_text = ascii_text.substring(0, ascii_text.length - 1) +
                chAscii[0] +
                ascii_text[ascii_text.length - 1];
            //alert ("ascii_text (എ, ഏ, റ): "+ascii_text);
          }
          if (chUnicode == "്ര") {
            bRepham = 1;
          }
        } else {
          //alert (chUnicode);
          bRepham = 0;
          ascii_text = ascii_text + chAscii;
          //alert ("ascii_text (none): "+ascii_text);
        }
        index = index + lenChar;
        break;
      } else {
        if (lenChar == 1) {
          ascii_text = ascii_text + chUnicode;
          index++;
          bRepham = 0;
        }
        //alert(ascii_text);
      }
    }
    //console.log(ascii_text);
  }
  return ascii_text;
}
