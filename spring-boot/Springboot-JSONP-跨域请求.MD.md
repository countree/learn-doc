# Springboot-JSONP-跨域请求

---

> 前端使用ajax jsonp跨域请求时,后端代码在返回json数据时，需要按照固定的格式返回。

一般跨域用到的两个方法为：`$.ajax` 和 `$.getJSON`

JSON官方文档：

JSON数据是一种能很方便通过JavaScript解析的结构化数据。如果获取的数据文件存放在远程服务器上（域名不同，也就是跨域获取数据），则需要使用jsonp类型。

使用这种类型的话，会创建一个查询字符串参数 `callback=?` ，这个参数会加在请求的URL后面。服务器端应当在JSON数据前加上回调函数名，以便完成一个有效的JSONP请求。如果要指定回调函数的参数名来取代默认的callback，可以通过设置$.ajax()的jsonp参数。
 
其实jquery跨域的原理是通过外链 `<script> ` 来实现的,然后在通过回调函数加上回调函数的参数来实现真正的跨域.
 
Jquery 在每次跨域发送请求时都会有`callback`这个参数，其实这个参数的值就是回调函数名称，所以，服务器端在发送json数据时，应该把这个参数放到前面，这个参数的值往往是随机生成的，如：`jsonp1899544999`，同时也可以通过 `$.ajax` 方法设置 `callback `方法的名称。所以服务器端应该这样返回数据：
 
    string message = "jsonp1294734708682({\"id\":0,\"userName\":\"hello\"})";
 
这样，json 数据`{\"id\":0,\"userName\":\"hello\"}` 就作为了 `jsonp1899544999` 回调函数的一个参数
##### Springboot 包装json返回数据
使用`fastjson`配置，`fastjson`本身自带`jsonp`数据包装，但是需要在相应的方法上增加注解.这里改造了下不使用注解根据请求参数自动判断是否是jsonp的请求,一下的类是仿照fastjson自带了类改写的。

包装类如下:
```
@ControllerAdvice(basePackages = "com.learn.hello")
public class JsonpResponseAdvice implements ResponseBodyAdvice<Object> {
    private static Logger LOGGER = LoggerFactory.getLogger(JsonpResponseAdvice.class);
    private static final String CALLBACK_NAME = "callback";

    public JsonpResponseAdvice() {

    }

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return FastJsonHttpMessageConverter.class.isAssignableFrom(converterType);
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
        String callbackMethodName = servletRequest.getParameter(CALLBACK_NAME);
        if (StringUtils.isBlank(callbackMethodName)) {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("Invalid jsonp parameter value:" + callbackMethodName);
            }
            callbackMethodName = null;
        }

        JSONPObject jsonpObject = new JSONPObject(callbackMethodName);
        jsonpObject.addParameter(body);
        this.beforeBodyWriteInternal(jsonpObject, selectedContentType, returnType, request, response);
        return jsonpObject;
    }

    public void beforeBodyWriteInternal(JSONPObject jsonpObject, MediaType contentType, MethodParameter returnType, ServerHttpRequest request, ServerHttpResponse response) {
    }

    protected MediaType getContentType(MediaType contentType, ServerHttpRequest request, ServerHttpResponse response) {
        return FastJsonHttpMessageConverter.APPLICATION_JAVASCRIPT;
    }
}
```

