### Springboot 未解

[TOC]

#### 模板引擎是怎么配置的
 Springboot中模板引擎的自动配置相关连有两个框架.
 `springboot`框架主要是做了自动配置,相关包和类有
 所有的自动配置相关的类都在这个包下面找
>包名：` org.springframework.boot.autoconfigure`

 `springframework`框架主要做了模板和`spring`的集成,主要相关的包和类有
>模板创建包名：`org.springframework.ui`
>模板视图渲染包名：`org.springframework.web.servlet.view`
`thymeleaf`不在这个包下
相关类类名
+ `AbstractTemplateView`
+ `AbstractTemplateViewResolver`
