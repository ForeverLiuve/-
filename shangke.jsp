<%@ page language="java"  pageEncoding="utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>课表信息管理</title>
<link rel="stylesheet" type="text/css" href="jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
	var url;
	
	function searchJsshangke(){
		$('#dg').datagrid('load',{
			jszhouId:$('#s_jszhouId').combobox("getValue"),
			jsjiaoshiId:$('#s_jsjiaoshiId').combobox("getValue"),
			jskechengId:$('#s_jskechengId').combobox("getValue"),
			jsshiduanId:$('#s_jsshiduanId').combobox("getValue"),
			jsxingqiId:$('#s_jsxingqiId').combobox("getValue")
		});
	}
	
	function deleteJsshangke(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要删除的数据！");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].jsshangkeId);
		}
		var ids=strIds.join(",");
		//输出选择的行
		//$.messager.alert("ids:" + ids);
		$.messager.confirm("系统提示","您确认要删掉这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("deleteJsshangke",{delIds:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","您已成功删除<font color=red>"+result.delNums+"</font>条数据！");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert('系统提示','<font color=red>'+selectedRows[result.errorIndex].jsshangkeName+'</font>'+result.errorMsg);
					}
				},"json");
			}
		});
	}
	
	function openJsshangkeAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","添加课表信息");
		url="addJsshangke";
	}
	
	function saveJsshangke(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				return $(this).form("validate");
			},
			success:function(result){
				if(result.errorMsg){
					$.messager.alert("系统提示",result.errorMsg);
					return;
				}else{
					$.messager.alert("系统提示","保存成功");
					resetValue();
					$("#dlg").dialog("close");
					$("#dg").datagrid("reload");
				}
			}
		});
	}
	
	function resetValue(){
		$("#jsshangkeName").val("");
		$("#jsshangkeMark").val("");
	}
	
	function closeJsshangkeDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	
	function openJsshangkeModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑课表信息");
		$("#fm").form("load",row);
		url="addJsshangke?jsshangkeId="+row.jsshangkeId;
	}
	
	function datetostr(date, row){
		var JsonDateValue = new Date(date.time);
		var text = JsonDateValue.toLocaleString(); 
		return text;
	}
	
</script>
</head>
<body style="margin: 5px;">
	<table id="dg" title="课表信息" class="easyui-datagrid" fitColumns="true"
	 pagination="true" url="getJsshangkes" fit="true" toolbar="#tb">
		<thead>
			<tr>
				<th field="cb" checkbox="true"></th>
				<th field="jsshangkeId" width="20">编号</th>
				<th field="jsshiduanId" width="50" align="center" hidden="true">课节ID</th>
				<th field="jsshiduanName" width="50" align="center">课节</th>
				<th field="jsjiaoshiId" width="50" align="center" hidden="true">教室ID</th>
				<th field="jsjiaoshiName" width="50" align="center">教室</th>
				<th field="jskechengId" width="50" align="center" hidden="true">课程ID</th>
				<th field="jskechengName" width="50" align="center">课程</th>
				<th field="jszhouId" width="50" align="center" hidden="true">学周ID</th>
				<th field="jszhouName" width="50" align="center">学周</th>
				<th field="jsxingqiId" width="50" align="center" hidden="true">星期ID</th>
				<th field="jsxingqiName" width="50" align="center">星期</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb">
		<div>
			<a href="javascript:openJsshangkeAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
			<a href="javascript:deleteJsshangke()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">删除</a>
		</div>
		<div>
		学周：&nbsp; <input class="easyui-combobox" id="s_jszhouId" name="s_jszhouId"  data-options="panelHeight:'auto',editable:false,valueField:'jszhouId',textField:'jszhouName',url:'jszhouComboList'"/>
		教室：&nbsp; <input class="easyui-combobox" id="s_jsjiaoshiId" name="s_jsjiaoshiId"  data-options="panelHeight:'auto',editable:false,valueField:'jsjiaoshiId',textField:'jsjiaoshiName',url:'jsjiaoshiComboList'"/>
		课程：&nbsp; <input class="easyui-combobox" id="s_jskechengId" name="s_jskechengId"  data-options="panelHeight:'auto',editable:false,valueField:'jskechengId',textField:'jskechengName',url:'jskechengComboList'"/>
		星期：&nbsp; <input class="easyui-combobox" id="s_jsxingqiId" name="s_jsxingqiId"  data-options="panelHeight:'auto',editable:false,valueField:'jsxingqiId',textField:'jsxingqiName',url:'jsxingqiComboList'"/>
		课节：&nbsp; <input class="easyui-combobox" id="s_jsshiduanId" name="s_jsshiduanId"  data-options="panelHeight:'auto',editable:false,valueField:'jsshiduanId',textField:'jsshiduanName',url:'jsshiduanComboList'"/>
		<a href="javascript:searchJsshangke()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 500px;height: 200px;padding: 10px 20px"
		closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table>
				<tr>
					<td>学周：</td>
					<td><input class="easyui-combobox" id="jszhouId" name="jszhouId"  data-options="panelHeight:'auto',editable:false,valueField:'jszhouId',textField:'jszhouName',url:'jszhouComboList'"/></td>
					<td>教室：</td>
					<td><input class="easyui-combobox" id="jsjiaoshiId" name="jsjiaoshiId"  data-options="panelHeight:'auto',editable:false,valueField:'jsjiaoshiId',textField:'jsjiaoshiName',url:'jsjiaoshiComboList'"/></td>
				</tr>
				<tr>
					<td>星期：</td>
					<td><input class="easyui-combobox" id="jsxingqiId" name="jsxingqiId"  data-options="panelHeight:'auto',editable:false,valueField:'jsxingqiId',textField:'jsxingqiName',url:'jsxingqiComboList'"/></td>
					<td>课节：</td>
					<td><input class="easyui-combobox" id="jsshiduanId" name="jsshiduanId"  data-options="panelHeight:'auto',editable:false,valueField:'jsshiduanId',textField:'jsshiduanName',url:'jsshiduanComboList'"/></td>
				</tr>
				<tr>
					<td>课程：</td>
					<td><input class="easyui-combobox" id="jskechengId" name="jskechengId"  data-options="panelHeight:'auto',editable:false,valueField:'jskechengId',textField:'jskechengName',url:'jskechengComboList'"/></td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:saveJsshangke()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeJsshangkeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
	
</body>
</html>