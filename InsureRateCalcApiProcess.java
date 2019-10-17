package com.apptomo.apim.apis.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.apptomo.apis.context.ApiContext;
import com.apptomo.apis.context.ApiResponse;
import com.apptomo.apis.exception.ApiException;
import com.apptomo.apis.message.MessageDto;

@RestController
@RequestMapping(value = "/v1.0/insure/rate/calc", produces = { "application/json; charset=UTF-8" })
public class InsureRateCalcApiProcess {
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)
	public ApiResponse g1(HttpServletRequest req, //
			HttpServletResponse res
	) {
		// new Exception("apiId : " + apiId).printStackTrace();

		ApiContext apiContext = ApiContext.makeInstance(req, res);
		System.out.println("[StubApiProcess-g1] apiReq : " + apiContext.getApiReq());

		return process(apiContext);
	}

	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)
	public ApiResponse p1(HttpServletRequest req, //
			HttpServletResponse res, //
			@RequestBody HashMap<String, Object> jsonMap
	) {
		// new Exception("jsonMap[" + apiId + "] : " + jsonMap).printStackTrace();

		ApiContext apiContext = ApiContext.makeInstance(req, res, jsonMap);
		System.out.println("[StubApiProcess-p1] apiReq : " + apiContext.getApiReq());

		return process(apiContext);
	}

	public ApiResponse process(ApiContext apiContext) {
		System.out.println("[StubApiProcess-process] ciNo : " + apiContext.getCiNo());
		System.out.println("[StubApiProcess-process] uuid : " + apiContext.getUuId());
		System.out.println("[StubApiProcess-process] method : " + apiContext.getMethod());
		System.out.println("[StubApiProcess-process] apiReq : " + apiContext.getApiReq());
		// System.out.println("[StubApiProcess-process] apiRes : " + apiContext.getApiRes());

		ApiResponse apiRes = apiContext.getApiRes();
		try {
			apiRes.setRetCodeMsg(new MessageDto("0004", "[대응답] 정상 조회되었습니다."));

			apiRes.putHeader("apiUrl", apiContext.getHttpReq().getRequestURL());
			apiRes.putHeader("name", apiContext.getHttpReq().getMethod());
			apiRes.putHeader(ApiResponse.HTTP_RES_JSON_DATA_HEADER_SUCCESS_CODE, ApiResponse.HTTP_RES_JSON_DATA_HEADER_SUCCESS_CODE_SUCCESS);

			/**
			 * GROUP 리턴시
			 */
			HashMap<String, Object> map = null;

			// 시작
			map = new HashMap<String, Object>();
			map.put("name", "일반상해사망 1,000만원");
			map.put("상해수술비", "50만원");
			map.put("질병수술비", "30만원");
			map.put("5대질환수술비(Ⅱ)(연간1회한)", "500만원");
			map.put("32대질병관혈수술비(연간1회한)", "200만원");
			map.put("64대질병수술비(7대질병)", "300만원");
			
			
			// 종료

			apiRes.putBody(map);
		} catch (Exception e) {
			/**
			 * 예외처리
			 */
			e.printStackTrace();
			
			apiRes.putHeader(ApiResponse.HTTP_RES_JSON_DATA_HEADER_CATEGORY, ApiResponse.HTTP_RES_JSON_DATA_HEADER_CATEGORY_API);
			apiRes.putHeader(ApiResponse.HTTP_RES_JSON_DATA_HEADER_SUCCESS_CODE, ApiResponse.HTTP_RES_JSON_DATA_HEADER_SUCCESS_CODE_FAIL);
			apiRes.putHeader(ApiResponse.HTTP_RES_JSON_DATA_HEADER_RESULT_CODE, "9999");
			apiRes.putHeader(ApiResponse.HTTP_RES_JSON_DATA_HEADER_RESULT_MESSAGE, e.getMessage());
		} finally {
			/**
			 * 협의체 API속성 정의 - 앱에서 필요(API단에서는 ByPass, 응답헤더에 재전송)
			 */
		}

		return apiRes;
	}

	public void response(ApiResponse apiRes, String apiId) throws ApiException {
		if ("calc".equals(apiId)) { // API00266 입금결과조회
			apiRes.putBody("startPrcsDt", "");
			apiRes.putBody("endPrcsDt", "");

			/**
			 * GROUP 리턴시
			 */
			HashMap<String, Object> map = null;
			ArrayList<HashMap<String, Object>> groupList = new ArrayList<HashMap<String, Object>>();

			// 시작
			map = new HashMap<String, Object>();
			map.put("receiptPrcsDt", "");
			map.put("bankCd", "");
			map.put("inAmt", "");
			map.put("accountNo", "");
			groupList.add(map);
			// 종료

			apiRes.putBody("group001", groupList);
		}

	}
}
