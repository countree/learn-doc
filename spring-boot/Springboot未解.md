## Springboot 未解


#### 模板引擎是怎么配置的
 Springboot中模板引擎的自动配置相关的有两个框架,Springboot和SpringFramework.

 `Springboot`框架主要是做了自动配置,相关包和类有
 所有的自动配置相关的类都在这个包下面找
>包名：` org.springframework.boot.autoconfigure`

 `SpringFramework`框架主要做了模板的生成和`spring`的集成,主要的包和类有
>模板创建相关：`org.springframework.ui`

>模板视图渲染相关：`org.springframework.web.servlet.view`

>`thymeleaf不在这些包下`

> 相关类类名
>+ `AbstractTemplateView`
>+ `AbstractTemplateViewResolver`

#### Controller Response 返回值操作
如果需要对`controller`返回的结果做特别的操作，有两个类
- `ResponseBodyAdvice`
- `HandlerMethodReturnValueHandler`

###### ResponseBodyAdvice 接口
这个接口主要是根据返回的数据转换类型做一些相应的操作
```java
public interface ResponseBodyAdvice<T> {
    boolean supports(MethodParameter var1, Class<? extends HttpMessageConverter<?>> var2);

    T beforeBodyWrite(T var1, MethodParameter var2, MediaType var3, Class<? extends HttpMessageConverter<?>> var4, ServerHttpRequest var5, ServerHttpResponse var6);
}
```
新建一个`bean`实现接口`ResponseBodyAdvice`,重写`beforeBodyWrite()`方法,主要是这个方法的参数提供了我们需要的信息,详见`springMvc`源码或`api`

###### HandlerMethodReturnValueHandler 接口
这个接口主要是根据请求方法的参数,做一些相应的操作.
```java
public interface HandlerMethodReturnValueHandler {
    boolean supportsReturnType(MethodParameter var1);

    void handleReturnValue(Object var1, MethodParameter var2, ModelAndViewContainer var3, NativeWebRequest var4) throws Exception;
}
```
#### Controller Request 请求参数操作
如果需要对`controller`请求做特别的操作，有两个类
- `HandlerMethodArgumentResolver`
- `RequestBodyAdvice`
###### HandlerMethodArgumentResolver
可以自定义`controller`方法中的实体类，在resolveArgument()方法中生成实体的实例并传入`controller`的方法参数中.
```java
public class ManagerMethodArgResolver implements HandlerMethodArgumentResolver {
    @Override
    public boolean supportsParameter(MethodParameter methodParameter) {
        return methodParameter.getParameterType().equals(OperationLog.class);
    }

    @Override
    public Object resolveArgument(MethodParameter methodParameter, ModelAndViewContainer modelAndViewContainer, NativeWebRequest nativeWebRequest, WebDataBinderFactory webDataBinderFactory) throws Exception {
        return nativeWebRequest.getAttribute(OperationLogInterceptor.OPERATION_LOG_REQUEST_ENTITY_NAME, RequestAttributes.SCOPE_REQUEST);
    }
}
```
###### RequestBodyAdvice
```java
public interface RequestBodyAdvice {
    boolean supports(MethodParameter var1, Type var2, Class<? extends HttpMessageConverter<?>> var3);

    Object handleEmptyBody(Object var1, HttpInputMessage var2, MethodParameter var3, Type var4, Class<? extends HttpMessageConverter<?>> var5);

    HttpInputMessage beforeBodyRead(HttpInputMessage var1, MethodParameter var2, Type var3, Class<? extends HttpMessageConverter<?>> var4) throws IOException;

    Object afterBodyRead(Object var1, HttpInputMessage var2, MethodParameter var3, Type var4, Class<? extends HttpMessageConverter<?>> var5);
}

```
