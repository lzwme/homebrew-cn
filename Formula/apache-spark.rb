class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz"
  version "3.4.0"
  sha256 "345174179387e836efdecdd3e1fe5a7129c198b6f720ad8b1d87ec08c0d1a205"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e48a73db17b4a372d8c51211debefbc9622b64413dc2c10a78533cc138384f56"
  end

  depends_on "openjdk@17"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk@17"].opt_prefix)
  end

  test do
    assert_match "Long = 1000",
      pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "sc.parallelize(1 to 1000).count()")
    assert_match "String = abi/trivial",
      pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "jdk.incubator.foreign.FunctionDescriptor.TRIVIAL_ATTRIBUTE_NAME")
  end
end