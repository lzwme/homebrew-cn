class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https:spark.apache.org"
  url "https:dlcdn.apache.orgsparkspark-3.5.2spark-3.5.2-bin-hadoop3.tgz"
  mirror "https:archive.apache.orgdistsparkspark-3.5.2spark-3.5.2-bin-hadoop3.tgz"
  version "3.5.2"
  sha256 "8a2a07b928516e971d4c8d287b6b55d35870ed111e19f32fea9d1aa39a88f836"
  license "Apache-2.0"
  head "https:github.comapachespark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https:spark.apache.orgjsdownloads.js"
    regex(addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7f6dff737b5fcba5f36a882ef888c8d152a47b42c06e9c128bbefc4588824c4"
  end

  depends_on "openjdk@17"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "binbeeline", "binspark-beeline"

    rm(Dir["bin*.cmd"])
    libexec.install Dir["*"]
    bin.install Dir[libexec"bin*"]
    bin.env_script_all_files(libexec"bin", JAVA_HOME: Language::Java.overridable_java_home_env("17")[:JAVA_HOME])
  end

  test do
    assert_match "Long = 1000",
      pipe_output(bin"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "sc.parallelize(1 to 1000).count()")
    assert_match "String = abitrivial",
      pipe_output(bin"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "jdk.incubator.foreign.FunctionDescriptor.TRIVIAL_ATTRIBUTE_NAME")
  end
end