#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "const.au3"

_startExecute() ;������ؽ���
Local Const $width = 145 ;ͼƬ�ؼ����
Local Const $height = 121 ;ͼƬ�ؼ��߶�
Local Const $left = 300 ;��һ��ͼƬ�ؼ������
$Form1 = GUICreate("PictureLogonPassword", 767, 384, 335, 582, BitOR($WS_SYSMENU,$WS_MAXIMIZE,$WS_POPUP)) ;����������
GUICtrlCreatePic(@ScriptDir & '\pic\' & IniRead(@ScriptDir & '\config.ini','Style','Background','bg.jpg'),0,0,@DesktopWidth,@DesktopHeight) ;���ñ���ͼƬ
GUICtrlSetState(-1,$GUI_DISABLE) ;��ͼƬ��Ϊ����
Local $Pic[5] ;����ͼƬ�ؼ�����
$Pic[1] = GUICtrlCreatePic('', $left,@DesktopHeight/2-$height/2,$width, $height) ;����ͼƬ�ؼ�����
$Pic[2] = GUICtrlCreatePic('', $left+$width+100,@DesktopHeight/2-$height/2,$width, $height)
$Pic[3] = GUICtrlCreatePic('', $left+$width*2+100*2,@DesktopHeight/2-$height/2,$width, $height)
$Pic[4] = GUICtrlCreatePic('', $left+$width*3+100*3,@DesktopHeight/2-$height/2,$width, $height)
GUISetState(@SW_SHOW)
_changePic() ;����ͼƬ

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		;Case $GUI_EVENT_CLOSE
			;Exit
		Case $Pic[1] ;����ͼƬ�ؼ�1�򴫵ݲ���1���Դ�����
			_checkPic(1)
		Case $Pic[2]
			_checkPic(2)
		Case $Pic[3]
			_checkPic(3)
		Case $Pic[4]
			_checkPic(4)
	EndSwitch
WEnd

Func _changePic()
	$pic_gp = Random(1,4,1) ;���ѡȡһ��ͼƬ���ڶ�������ȡ����ͼƬ������
	$pic_ts = $nq[Random(0,23,1)] ;�����������ѡȡһ�������м�const.au3�ļ�
	$pic_temp = StringSplit($pic_ts,'') ;��4���ַ����ַ����ֳ�һ������
	$pic_temp[0] = $pic_gp ;$pic_temp[0]����ѡȡ��ͼƬ���
	Local $i = 1
	For $i = 1 To 4
		GUICtrlSetImage($pic[$i],@ScriptDir & '\pic\' & $pic_gp & '-' & $pic_temp[$i] & '.bmp') ;�ֱ�����ͼƬ����ʾ��ע��bmp���Ը�Ϊjpg
	Next
EndFunc  ;==>_changePic

Func _checkPic($n)
	Local $tCheck = $pic_temp[$n] ;ʶ�������µ�ͼƬ�ؼ���
	If $tCheck = $answer[$pic_temp[0]] Then ;����ȷ���������ж�ȡ�������ȷ���벢�Ա�
		$res &= '1' ;��ȷ�����1
	Else
		$res &= '0' ;��������0
	EndIf
	If StringLen($res) = 4 Then ;�ַ��ĳ��ȼ�Ϊ��ͼƬ�Ĵ���
		If $res = '1111' Then ;����1�����������Ƶ�ͼƬ�Ĵ���
			_endExecute()  ;�ָ�explorer.exe��
			Run('explorer.exe')
			_readJournal()  ;��ȡ��־
			Exit
		Else
			_writeJournal()  ;����Ϣд����־
			_endExecute()  ;�ָ�explorer.exe��
			Shutdown(2)  ;����
			Exit
		EndIf
	Else
		_changePic() ;û�е��㹻�Ĵ����͸���ͼƬ
	EndIf
EndFunc ;==>_checkPic

Func _startExecute() ;������ؽ��̲���ע����н������������
	ShellExecute('taskkill.exe','/im explorer.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im explorer.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im explorer.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im cmd.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im taskmgr.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im TM.exe /f','','open',@SW_HIDE)
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe','debugger','REG_SZ',@ScriptDir & '\substitute.exe')
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TM.exe','debugger','REG_SZ',@ScriptDir & '\substitute.exe')
EndFunc ;==>_startExecute

Func _endExecute() ;�ָ����������
	RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe','debugger')
	RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TM.exe','debugger')
EndFunc ;==>_endExecute

Func _writeJournal() ;�������ʱ����¼
	Local $file = FileOpen(@ScriptDir & '\journal.txt',32+1)
	FileWriteLine($file,@YEAR & '��' & @MON & '��' & @MDAY & '��' & ' ' & $week[@WDAY] & '  ' & @HOUR & 'ʱ' & @MIN & '��')
	FileClose($file)
EndFunc

Func _readJournal() ;��ȡ��¼
	If FileExists(@ScriptDir & '\journal.txt') Then
		Local $file = FileOpen(@ScriptDir & '\journal.txt',32)
		Local $journal = FileReadToArray($file)
		FileClose($file)
		FileDelete(@ScriptDir & '\journal.txt')
		Local $i = 0
		Local $jnl_s
		For $i = 0 To UBound($journal)-1
			$jnl_s &= $journal[$i] & @CRLF
		Next
		MsgBox(64,Default,'����������������ʱ����ִ���' & @CRLF & @CRLF & $jnl_s & @CRLF & '��ȷ���Ƿ��˲�����')
	EndIf
EndFunc