#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "const.au3"

_startExecute() ;结束相关进程
Local Const $width = 145 ;图片控件宽度
Local Const $height = 121 ;图片控件高度
Local Const $left = 300 ;第一个图片控件的左距
$Form1 = GUICreate("PictureLogonPassword", 767, 384, 335, 582, BitOR($WS_SYSMENU,$WS_MAXIMIZE,$WS_POPUP)) ;创建主窗体
GUICtrlCreatePic(@ScriptDir & '\pic\' & IniRead(@ScriptDir & '\config.ini','Style','Background','bg.jpg'),0,0,@DesktopWidth,@DesktopHeight) ;设置背景图片
GUICtrlSetState(-1,$GUI_DISABLE) ;将图片设为背景
Local $Pic[5] ;创建图片控件数组
$Pic[1] = GUICtrlCreatePic('', $left,@DesktopHeight/2-$height/2,$width, $height) ;创建图片控件数组
$Pic[2] = GUICtrlCreatePic('', $left+$width+100,@DesktopHeight/2-$height/2,$width, $height)
$Pic[3] = GUICtrlCreatePic('', $left+$width*2+100*2,@DesktopHeight/2-$height/2,$width, $height)
$Pic[4] = GUICtrlCreatePic('', $left+$width*3+100*3,@DesktopHeight/2-$height/2,$width, $height)
GUISetState(@SW_SHOW)
_changePic() ;加载图片

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		;Case $GUI_EVENT_CLOSE
			;Exit
		Case $Pic[1] ;点中图片控件1则传递参数1，以此类推
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
	$pic_gp = Random(1,4,1) ;随机选取一组图片，第二个参数取决于图片的组数
	$pic_ts = $nq[Random(0,23,1)] ;从序列中随机选取一个，序列见const.au3文件
	$pic_temp = StringSplit($pic_ts,'') ;把4个字符的字符串分成一个数组
	$pic_temp[0] = $pic_gp ;$pic_temp[0]储存选取的图片组别
	Local $i = 1
	For $i = 1 To 4
		GUICtrlSetImage($pic[$i],@ScriptDir & '\pic\' & $pic_gp & '-' & $pic_temp[$i] & '.bmp') ;分别设置图片并显示，注意bmp可以改为jpg
	Next
EndFunc  ;==>_changePic

Func _checkPic($n)
	Local $tCheck = $pic_temp[$n] ;识别所按下的图片控件号
	If $tCheck = $answer[$pic_temp[0]] Then ;在正确密码序列中读取该组的正确密码并对比
		$res &= '1' ;正确的添加1
	Else
		$res &= '0' ;错误的添加0
	EndIf
	If StringLen($res) = 4 Then ;字符的长度即为点图片的次数
		If $res = '1111' Then ;控制1的数量来控制点图片的次数
			_endExecute()  ;恢复explorer.exe等
			Run('explorer.exe')
			_readJournal()  ;读取日志
			Exit
		Else
			_writeJournal()  ;将信息写入日志
			_endExecute()  ;恢复explorer.exe等
			Shutdown(2)  ;重启
			Exit
		EndIf
	Else
		_changePic() ;没有点足够的次数就更换图片
	EndIf
EndFunc ;==>_checkPic

Func _startExecute() ;结束相关进程并在注册表中禁用任务管理器
	ShellExecute('taskkill.exe','/im explorer.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im explorer.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im explorer.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im cmd.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im taskmgr.exe /f','','open',@SW_HIDE)
	ShellExecute('taskkill.exe','/im TM.exe /f','','open',@SW_HIDE)
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe','debugger','REG_SZ',@ScriptDir & '\substitute.exe')
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TM.exe','debugger','REG_SZ',@ScriptDir & '\substitute.exe')
EndFunc ;==>_startExecute

Func _endExecute() ;恢复任务管理器
	RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe','debugger')
	RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TM.exe','debugger')
EndFunc ;==>_endExecute

Func _writeJournal() ;密码错误时作记录
	Local $file = FileOpen(@ScriptDir & '\journal.txt',32+1)
	FileWriteLine($file,@YEAR & '年' & @MON & '月' & @MDAY & '日' & ' ' & $week[@WDAY] & '  ' & @HOUR & '时' & @MIN & '分')
	FileClose($file)
EndFunc

Func _readJournal() ;读取记录
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
		MsgBox(64,Default,'开机密码曾于以下时间出现错误：' & @CRLF & @CRLF & $jnl_s & @CRLF & '请确认是否本人操作。')
	EndIf
EndFunc