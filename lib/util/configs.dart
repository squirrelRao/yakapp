
class Configs {

  //apis:
  static const String baseUrl = "http://lakewater.cn";
  static const String registApi = baseUrl +"/v1/regist";
  static const String checkRegistApi = baseUrl + "/v1/regist/check/phone";
  static const String loginApi = baseUrl +"/v1/login";
  static const String getBindInfo = baseUrl + "/v1/bind/info";
  static const String bindApi = baseUrl +"/v1/bind_exchange";
  static const String getAssetsApi = baseUrl +"/v1/assets/detail";
  static const String getUserInfo = baseUrl + "/v1/get/user";
  static const String getAssetConfigApi = baseUrl + "/v1/query/asset/config";
  static const String updateAssetConfigApi = baseUrl +"/v1/asset/config";
  static const String updateUserConfigApi = baseUrl +"/v1/user/config";
  static const String getUserTransactionsApi = baseUrl +"/v1/query/order";
  static const String modifyPasswordApi = baseUrl +"/v1/passwd/update";
  static const String getNoticeApi = baseUrl +"/v1/notice/get";
  static const String getPreBuyOrderApi = baseUrl +"/v1/prebuy/get";
  static const String updatePreBuyOrderApi = baseUrl +"/v1/prebuy/new";
  static const String syncHistoryApi = baseUrl +"/v1/sync/history";



  static const String checkSystemStatusApi = baseUrl +"/v1/regist";
  static const String checkUserStatusApi = baseUrl +"/v1/regist";

  static const String syncOrderApi = baseUrl +"/v1/remote/order/sync";

}
