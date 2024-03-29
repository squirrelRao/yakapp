
class Configs {

  //apis:
  static const String baseUrl = "https://lakewater.cn";
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
  static const String getFitValueApi= baseUrl +"/v1/fitvalue/get";
  static const String syncOrderApi = baseUrl +"/v1/remote/order/sync";
  static const String getFitValueConfigApi = baseUrl +"/v1/fitvalue/config/get";
  static const String updateFitValueConfigApi = baseUrl +"/v1/fitvalue/config/update";
  static const String getMarketTarget = baseUrl +"/v1/market/target/get";
  static const String addMarketTarget = baseUrl + "/v1/market/target/add";
  static const String removeMarketTarget = baseUrl + "/v1/market/target/remove";
  static const String updateMarketTarget = baseUrl +"/v1/market/target/update";
  static const String getPredictDetail = baseUrl +"/v1/market/predict/detail";
  static const String getUserGrids = baseUrl +"/v1/grid/query";
  static const String getUserGridDetail = baseUrl +"/v1/grid/query/detail";
  static const String modifyUserGrid = baseUrl +"/v1/grid/modify";
  static const String createUserGrid = baseUrl +"/v1/grid/create";



}
