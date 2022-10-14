class ApiUtils {
  static const baseUrl = "https://api.bricolidari.com/api/";
  static const login = "${baseUrl}auth/loginCategoryy";
  static const getAllOrders = "${baseUrl}order/latest/find?username=";
  static const getOrder = "order/byOrderNumber/?ordernumber=";
  static const getCategory = "categories";
  static const getService = "services";
  static const createOrder = "${baseUrl}order";
  static const getAllPrices = "${baseUrl}price";
  static const serviceByCategory = "services/byCategory/";
  static const states = "states";
}
