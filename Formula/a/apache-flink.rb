class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https:flink.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=flinkflink-1.18.0flink-1.18.0-bin-scala_2.12.tgz"
  mirror "https:archive.apache.orgdistflinkflink-1.18.0flink-1.18.0-bin-scala_2.12.tgz"
  version "1.18.0"
  sha256 "9b0969471fec9da4f2982b9b54b4e7bcde52a573b611697da99f2c78db4d2ad2"
  license "Apache-2.0"
  head "https:github.comapacheflink.git", branch: "master"

  livecheck do
    url "https:flink.apache.orgdownloads"
    regex(href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8429a52884cc5d631d693cae127f81ebb03d7069f3ecc4b5e1cfdfe65884c243"
  end

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin*.bat"]
    libexec.install Dir["*"]
    (libexec"bin").env_script_all_files(libexec"libexec", Language::Java.java_home_env("11"))
    (libexec"bin").install Dir["#{libexec}libexec*.jar"]
    chmod 0755, Dir["#{libexec}bin*"]
    bin.write_exec_script "#{libexec}binflink"
  end

  test do
    (testpath"log").mkpath
    (testpath"input").write "foo bar foobar"
    expected = <<~EOS
      (foo,1)
      (bar,1)
      (foobar,1)
    EOS
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", testpath"log"
    system libexec"binstart-cluster.sh"
    system bin"flink", "run", "-p", "1",
           libexec"examplesstreamingWordCount.jar", "--input", testpath"input",
           "--output", testpath"result"
    system libexec"binstop-cluster.sh"
    assert_predicate testpath"result", :exist?
    result_files = Dir[testpath"result**"]
    assert_equal 1, result_files.length
    assert_equal expected, (testpathresult_files.first).read
  end
end