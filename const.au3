#include-once
Global Const $answer[5] = ['',IniRead(@ScriptDir & '\config.ini','Password','Group1',4),IniRead(@ScriptDir & '\config.ini','Password','Group2',4),IniRead(@ScriptDir & '\config.ini','Password','Group3',4),IniRead(@ScriptDir & '\config.ini','Password','Group4',4)] ;ÿ��ͼƬ����ȷͼƬ�ţ�ע���м���ͼƬ���м������֣���һ��������Ҫɾ��
Global Const $nq[] = [1234,1243,1324,1342,1432,1423,2134,2143,2314,2341,2431,2413,3214,3241,3124,3142,3412,3421,4231,4213,4321,4312,4132,4123] ;��������
Global Const $week[] = ['','������','����һ','���ڶ�','������','������','������','������']
Global $pic_temp[5] = ['','','','','']
Global $res = ''