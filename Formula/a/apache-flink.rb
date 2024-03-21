class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https:flink.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=flinkflink-1.19.0flink-1.19.0-bin-scala_2.12.tgz"
  mirror "https:archive.apache.orgdistflinkflink-1.19.0flink-1.19.0-bin-scala_2.12.tgz"
  version "1.19.0"
  sha256 "3119c6db3a8f4813defce1c89cac46111df9d0cb9712a264da0b3a3b7290bf86"
  license "Apache-2.0"
  head "https:github.comapacheflink.git", branch: "master"

  livecheck do
    url "https:flink.apache.orgdownloads"
    regex(href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0983dd623b462b2b57af833026029eb7db3367469d1605d3597a985fc42adb23"
  end

  depends_on "openjdk@11"

  def install
    inreplace "confconfig.yaml" do |s|
      s.sub!(^env:, "env.java.home: #{Language::Java.java_home("11")}\n\\0")
    end
    libexec.install Dir["*"]
    bin.write_exec_script libexec"binflink"
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