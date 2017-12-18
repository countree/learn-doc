# Springboot-Redis-序列化

---

Spring boot默认提供`jackson`对`redis`数据序列化。使用jackson序列化`hibernate`的`entity`时，如果entity中有`many-to-many`或`many-to-one`,jackson序列化entity时会把`每一个字段`的类型的`类全名`序列化到`redis`中(具体可以查看`redis`中生成的`json`数据)。

当从redis中反序列化数据为entity时，会报`no session 异常`。

##### no session 异常原因

> 反序列化的时候会根据`类名称`生成相应的类。但是`hibernate`的`entity`中的`many-to-many`中的`List`被hibernate代理成了`PersistentList`，在实例化`PersistentList`的时候需要使用session查询数据库。所以会报 no session异常。

##### 解决方法

> 使用`fastjson`作为`redis`的默认序列化，fastjson在序列化的时候只是把当前的`entity的类名称`生成到json中，
不生成每个字段的类型。
>但是配置fastjson的时候还要设置一下全局的反序列化的配置为自动检测类型（否则会报 autoType not support异常）。

######  Fastjson反序列化配置
[设置Fastjson反序列化自动检测类型](https://github.com/alibaba/fastjson/wiki/enable_autotype)
```
FastJsonRedisSerializer<Object> fastJsonRedisSerializer = new FastJsonRedisSerializer<>(Object.class);
FastJsonConfig fastJsonConfig = new FastJsonConfig();
//序列化时设置添加类名称
fastJsonConfig.setSerializerFeatures(SerializerFeature.WriteClassName, SerializerFeature.WriteNullStringAsEmpty, SerializerFeature.WriteNullListAsEmpty);
//反序列化时设置自动匹配Object类型,这个是设置全局的反序列话是自动匹配
ParserConfig.getGlobalInstance().setAutoTypeSupport(true);
fastJsonRedisSerializer.setFastJsonConfig(fastJsonConfig);
// 设置默认的序列化规则为fastJson
redisTemplate.setDefaultSerializer(fastJsonRedisSerializer);
```



