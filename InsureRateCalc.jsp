<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>APIExam</title>
</head>
<script type="text/javascript" src="../resources/js/jquery-1.8.3.min.js" charset="utf-8"></script>
<script type="text/javascript">
var j$=jQuery;          <%--    ���� jquery $ �� �浹�Ͽ� ���� �����Ͽ� ��� �� --%>
j$(function($){
	/* ----------------------------------
	document ready
	---------------------------------- */
	$(document).ready(function(){
		$("#btnAssemble").click(function(){
			reqAssemble();
		});
		
	});
});

function reqAssemble() {
	var name = $("#name").val();
	var birthday = $("#birthday").val();
	var gender = $("#gender").val();
	var phone = $("#phone").val();

    var fmdata = $("#inputForm").find(":text, :hidden, :radio");
    var reqJsonStr = JSON.stringify({dataBody:{
    	name: fmdata[0].value,
    	birthday: fmdata[1].value,
    	gender: fmdata[2].value,
    	phone: fmdata[3].value
    }});
    
    jQuery.ajax({
        type: 'post'
        , headers : {
        	'name': name,
        	'birthday' : birthday,
        	'gender' : gender
        }
        , async: true
        , cache: false
        , url: 'http://localhost:9080/apis/v1.0/insure/rate/calc'
        , dataType: 'json'
        , contentType: 'application/json'
        , data: reqJsonStr
        , beforeSend: function() {
        	$("#apiRslt2").text("");
        }
        , success: function(data) {
            $("#apiRslt").text(JSON.stringify(data));
        }
        , error: function(data, status, err) {
            alert('�������� ����� �����߽��ϴ�. ' + err);
        }
        , complete: function(data) {
        }
    });
    
}
</script>
<style>
li{list-style:none;}
</style>
<body>

<form name="inputForm" id="inputForm" method="POST">
<fieldset>
<H1>�� ����� Ȯ���ϱ�</H1>
	<section>
		<ul>
			<li>�̸� : <input type="text" name="name" id="name" placeholder="�̸�"></li><br>
			<li>������� : <input type="text" name="birthday" id="birthday" placeholder="8�ڸ�(19841028)"></li><br>
			<li>���� : <input type="radio" name="gender" checked>��&nbsp;<input type="radio" name="gender">��</li><br>
			<li>����ó : <input type="text" name="phone" id="phone" placeholder="- ���� �Է��ϼ���"></li><br>
			<button type="button" id="btnAssemble">��ûJSON����</button>
			<li><textarea id="apiRslt" cols="100" rows="20" disabled></textarea></li>
		</ul>
	</section>
</fieldset>
</form>
</body>
</html>
