<%@ page pageEncoding="UTF-8" session="true"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="com.apptomo.util.DateUtil"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>UNO OpenAPI Platform :: API Tester</title>
<link rel="stylesheet" type="text/css" href="../resources/css/default.css?dummy=20140109" />
<link rel="stylesheet" type="text/css" href="../resources/css/sub.css?dummy=20140109" />
<link rel="stylesheet" type="text/css" href="../resources/css/popup.css?dummy=20140109" />
<script type="text/javascript" src="../resources/js/jquery-1.8.3.min.js" charset="utf-8"></script>
</head>

<%--
/*
 **************************************************************************
 * @source  : APITester.jsp
 * @desc    : AppTomo APIM v4 API 테스트 클라이언트
 * @author  : 박용우
 * @date    : 2019-10-16
 **************************************************************************
 */
--%>

<%
	String baseUrl = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/apis";

	String apiUrl = baseUrl + "/v1.0/stub/hello";
	String oAuthKey = "Bearer 99bd01b8-53e3-4aaf-be62-433815ed9be9";
	String ciNo = "E4PIs45uiscs8quYnySoQXuZKwjB66mE3Wqvw9gRuWOqMON3FiLQt+U4ZV42Y1+prQWpFWWnbKomShR+O5dHlg==";

	String inputJsonString = "" //
		+ "{\\n"//
		+ "	\"dataHeader\"	: { \\n"//
		+ "		\"udId\"	: \"UDID\", \\n"//
		+ "		\"subChannel\"	: \"박용우\", \\n"//
		+ "		\"deviceOs\"	: \"Android\", \\n"//
		+ "		\"carrier\"	: \"KT\", \\n"//
		+ "		\"connectionType\"	: \"..\", \\n"//
		+ "		\"appName\"	: \"..\", \\n"//
		+ "		\"appVersion\"	: \"..\", \\n"//
		+ "		\"hsKey\"	: \"body 전문검증\", \\n"//
		+ "		\"scrNo\"	: \"0000\"	\\n"//
		+ "	}, \\n"//
		+ "	\"dataBody\"	: { \\n"//
		+ "		\"reqGbnCd\"	: \"1\" \\n"//
		+ "	} \\n"//
		+ "}";//
%>

<script type="text/javascript">
$.support.cors = true;

var j$=jQuery;          <%--    기존 jquery $ 와 충돌하여 별도 선언하여 사용 함 --%>
j$(function($){
	/* ----------------------------------
	document ready
	---------------------------------- */
	$(document).ready(function(){
		console.log("ready");

		$("#btnToken").click(function(){
			reqToken();
		});

		$("#btnExcute").click(function(){
			reqAPI();
		});

		$("#checkToken").change(function(){
			if($("#checkToken").is(":checked")){
				$("#oAuthKey").removeAttr("readOnly");
				$("#oAuthKey").css("background-color","white");
			} else {
				$("#oAuthKey").attr("readOnly","true");
				$("#oAuthKey").css("background-color","#cccccc");
			}
		});

		$("#checkCiNo").change(function(){
			if($("#checkCiNo").is(":checked")){
				$("#ciNo").removeAttr("readOnly");
				$("#ciNo").css("background-color","white");
			} else {
				$("#ciNo").attr("readOnly","true");
				$("#ciNo").css("background-color","#cccccc");
			}
		});
		//$("#apiId").change(function(){
			//$("#apiUrl").val('/apis/engine/' + $("#apiId").val());
		//});

		$("#apiUrl").val('<%=apiUrl%>');
		$("#oAuthKey").val('<%=oAuthKey%>');
		$("#ciNo").val('<%=ciNo%>');

		var reqJsonText = '';
		reqJsonText += '{\n';
		reqJsonText += '    "dataHeader": {\n';
		reqJsonText += '        "subChannel": "01",\n';
		reqJsonText += '        "deviceOs": "Windows",\n';
		reqJsonText += '        "carrier": "KT",\n';
		reqJsonText += '        "connectionType": "MOBILE",\n';
		reqJsonText += '        "appName": "testWEB",\n';
		reqJsonText += '        "appVersion": "1.0.0",\n';
		reqJsonText += '        "udId": "UDID",\n';
		reqJsonText += '        "scrNo": "0000"\n';
		reqJsonText += '    },\n';
		reqJsonText += '    "dataBody": {\n';
		reqJsonText += '    }\n';
		reqJsonText += '}\n';

		$("#reqJson").text('<%=inputJsonString%>');
		//$("#apiId").val("SHC_HPG00548");
		//$("#apiReq").val('{"DataHeader":{},"DataBody":{"b1":"4","b2":"5","b3":"6"}}');
	});

});

function valid_check(){
	if($("#apiId").val().trim() == ""){
		alert("API ID를 입력하세요.");
		return false;
	}

	if($("#apiReq").val().trim() == ""){
		alert("Request 를 입력하세요.");
		return false;
	}

	return true;
}

function reqToken() {
	var ciNo = $("#ciNo").val();

	//uri = $("#apiUrl").val() + '/token?ciNo=' + ciNo;
	uri = '<%=baseUrl%>/tools/token';
    jQuery.ajax({
        type: "GET"
       	, headers : {'ciNo' : ciNo}
        , async: true
        , cache: false
        , url: uri
        , dataType: 'json'
        , contentType:"application/x-www-form-urlencoded; charset=UTF-8"
        , success: function(data) {
            $("#oAuthKey").val("Bearer " + data.accessToken);
        }
        , error: function(data, status, err) {
            alert('서버와의 통신이 실패했습니다. ' + err);
        }
    });
}

function reqAPI() {
	var apiId = $("#apiId").val();
	var reqJson = $("#reqJson").val();
	var _method = $("input:radio[name=method]:checked").val();
	var oAuthKey = $("#oAuthKey").val();
	var ciNo = $("#ciNo").val();
	var reqJson = $("#reqJson").text();

	uri = $("#apiUrl").val();
//	uri = '<%=baseUrl%>/tools/gateway';
	//alert(encodeURIComponent("한글"));
    jQuery.ajax({
        type: _method
        , headers : {
        	'Authorization': oAuthKey,
        	'ciNo' : ciNo
        }
        , async: true
        , cache: false
        , url: uri
        , dataType: 'json'
        , contentType: 'application/json'
        , data: reqJson
        , beforeSend: function() {
        	$("#apiRslt").text("");
        }
        , success: function(data) {
            $("#apiRslt").text(JSON.stringify(data));
        }
        , error: function(data, status, err) {
            alert('서버와의 통신이 실패했습니다. ' + err);
        }
        , complete: function(data) {
        }
    });
}

function testSend(){
	document.tstFrm.apiUrl.value = document.tstFrm.testUrl.value;
}

</script>

<body>

<center>

<form name="tstFrm" id="tstFrm" method="POST">

<table>
	<colgroup>
		<col width="200px" />
		<col width="*" />
	</colgroup>
	<br />

	<tr>
		<td colspan="2">
			<br />
			<center><h1 style="font-size: 30;">OpenAPI Platform :: API Tester</h1></center>
			<br />
			<br />
		</td>
	</tr>

	<tr>
		<th align="right" style="padding-right: 10px;">ciNo :</th>
		<td style="font-size: 11px;"><input style="background-color: #cccccc;" readOnly type="text" name="ciNo" id="ciNo" value="<%=ciNo%>" size=100% style="height: 25px;" />&nbsp;<input type="checkbox" id="checkCiNo" name="Edit">수정</td>
	</tr>
	<tr>
		<th align="right" style="padding-right: 10px;"></th>
		<td style="font-size: 11px;"><button type="button" id="btnToken" style="width: 100px;">Token발급</button></td>
	</tr>
	<tr>
		<th align="right" style="padding-right: 10px; vertical-align: top;">API URL :</th>
		<td style="font-size: 11px;">
			<input type="text" name="apiUrl" id="apiUrl" value="" size=100% style="height: 25px;" /><br>
			<select id="testUrl" name="testUrl" onChange="testSend();" >
				<option vlaues="'<%=baseUrl%>'/v1.0/stub/hello"><%=baseUrl%>/v1.0/stub/hello</option>
				<option vlaues="'<%=baseUrl%>'/v1.0/stub/hello?name=홍길동"><%=baseUrl%>/v1.0/stub/hello?name=홍길동</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/echo'"><%=baseUrl%>/v1.0/stub/echo</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API10694_APPR'"><%=baseUrl%>/v1.0/stub/auto/API10694_APPR</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API00236'"><%=baseUrl%>/v1.0/stub/auto/API00236</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API01096'"><%=baseUrl%>/v1.0/stub/auto/API01096</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API10685'"><%=baseUrl%>/v1.0/stub/auto/API10685</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API10686'"><%=baseUrl%>/v1.0/stub/auto/API10686</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API00425'"><%=baseUrl%>/v1.0/stub/auto/API00425</option>
				<option vlaues="'<%=baseUrl%>/v1.0/stub/auto/API00266'"><%=baseUrl%>/v1.0/stub/auto/API00266</option>
			</select>
		</td>
	</tr>
	<tr>
		<th align="right" style="padding-right: 10px;">ACCESS/REFRESH :</th>
		<td style="font-size: 11px;"><input style="background-color: #cccccc;" readOnly type="text" name="oAuthKey" id="oAuthKey" value=" / " size=100% style="height: 25px;" />&nbsp;<input type="checkbox" id="checkToken" name="Edit">수정</td>
	</tr>
	<tr>
		<th align="right" style="padding-right: 10px;">HTTP메소드 :</th>
		<td style="font-size: 11px; height: 25px;">
			<input type="radio" value="GET" name="method">GET</input>&nbsp;
			<input type="radio" value="POST" name="method" checked="checked">POST</input>&nbsp;
			<input disabled type="radio">PUT</input>&nbsp;
			<input disabled type="radio">DELETE</input></td>
	</tr>
	<tr>
		<th align="right" style="padding-right: 10px; vertical-align: top;">요청JSON전문 :</th>
		<td><textarea id="reqJson" name="reqJson" cols="100" rows="20" style="font-size: 11px; width: 100%;"></textarea></td>
	</tr>
	<tr>
		<th></th>
		<td align="center" height="50px">
		<button type="button" id="btnExcute" style="width: 100px;">실행</button>
		</td>
	</tr>
	<tr>
		<th align="right" style="padding-right: 10px; vertical-align: top;">응답JSON전문 :</th>
		<td><textarea id="apiRslt" cols="100" rows="20" style="font-size: 11px; width: 100%;"></textarea></td>
	</tr>
	<tr>
		<td></td>
		<td>
			<center><h3 style="font-size: 12;">Open API Platform powered by AppTomo APIM v4 of Universal Real-time</h3></center>
		</td>
	</tr>

</table>
</form>

</body>

</center>

</html>
