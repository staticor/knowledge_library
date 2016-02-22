



比如手上有个全球的天气数据, 先来看一个shell下awk处理的代码, 作为串行的代表:

```shell

#!/usr/bin/env bash

for year in all/*

do

  echo -ne `basename $year .gz`"\t"

  gunzip -c $year | \

    awk '{ temp = substr($0, 88, 5) + 0;

           q = substr($0, 93, 1);

           if (temp !=9999 && q ~ /[01459]/ && temp > max) max = temp }

         END { print max }'

done

```

> 代码片段来自 Hadoop: The Definitive Guide 4 th Edition , 目的是求每年的最高温度.

但是, 我们会不会这么想, 如果每年处理要5分钟, 有100年就得500分钟(8个小时), 能不能每年将由一个节点处理, 然后再将100个结果汇总到一起?

![](~/19-55-35.jpg)

> 图源: Hadoop: The Definitive Guide 4 th Edition

mapper of java

```java

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;

import org.apache.hadoop.io.LongWritable;

import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapreduce.Mapper;

public class MaxTemperatureMapper

    extends Mapper<LongWritable, Text, Text, IntWritable> {

  private static final int MISSING = 9999;

  @Override

  public void map(LongWritable key, Text value, Context context)

      throws IOException, InterruptedException {

    String line = value.toString();

    String year = line.substring(15, 19);

    int airTemperature;

    if (line.charAt(87) == '+') { // parseInt doesn't like leading plus signs

      airTemperature = Integer.parseInt(line.substring(88, 92));

    } else {

      airTemperature = Integer.parseInt(line.substring(87, 92));

    }

    String quality = line.substring(92, 93);

    if (airTemperature != MISSING && quality.matches("[01459]")) {

      context.write(new Text(year), new IntWritable(airTemperature));

    }

  }

}

```

reducer of java

```java

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;

import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapreduce.Reducer;

public class MaxTemperatureReducer

    extends Reducer<Text, IntWritable, Text, IntWritable> {

  @Override

  public void reduce(Text key, Iterable<IntWritable> values, Context context)

      throws IOException, InterruptedException {

    int maxValue = Integer.MIN_VALUE;

    for (IntWritable value : values) {

      maxValue = Math.max(maxValue, value.get());

    }

    context.write(key, new IntWritable(maxValue));

  }

}

```

> 代码片段来自 Hadoop: The Definitive Guide 4 th Edition



