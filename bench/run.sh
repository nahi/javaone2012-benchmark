#!/bin/bash -

JAVA_DIR=/home/nahi/git/examples/javaone-tokyo-2012/red-black
JRUBY_DIR=/home/nahi/git/javaone-tokyo-bof-jruby
GROOVY_DIR=/home/nahi/git/javaone-tokyo-bof-groovy
GROOVY_PP_DIR=/home/nahi/git/javaone-tokyo-bof-groovy-pp
SCALA_DIR=/home/nahi/git/javaone-tokyo-bof-scala
RESOURCE_FILES=/home/nahi/git/javaone-tokyo-bof-jruby/resource/*.csv
#RESOURCE_FILES=/home/nahi/git/javaone-tokyo-bof-jruby/resource/10000.csv

for i in $RESOURCE_FILES
do echo $i
  echo "Java"
  cd $JAVA_DIR
  for c in {1..5}
  do
    java Benchmark $i
  done

  echo "JRuby"
  cd $JRUBY_DIR
  for c in {1..5}
  do
    /home/nahi/git/jruby/bin/jruby -Xinvokedynamic.cache.ivars=true -Xcompile.invokedynamic.all=true -X+C -Ilib bench/bench.rb $i
  done

  echo "Groovy"
  cd $GROOVY_DIR
  ./gradlew benchmark -Dinput=$i -Dtrials=5

  echo "Groovy++"
  cd $GROOVY_PP_DIR
  ./gradlew benchmark -Dinput=$i -Dtrials=5

  echo "Scala(mutable)"
  cd $SCALA_DIR
  for c in {1..5}
  do
    java -cp target/javaone-tokyo-2012-jvm-bof-assembly-0.1.jar org.scala_users.jp.bench.Benchmark $i
  done

  echo "Scala(immutable)"
  for c in {1..5}
  do
    java -cp target/javaone-tokyo-2012-jvm-bof-assembly-0.1.jar org.scala_users.jp.bench.Benchmark $i immutable
  done
done
