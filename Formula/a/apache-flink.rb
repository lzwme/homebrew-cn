class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https:flink.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=flinkflink-1.20.0flink-1.20.0-bin-scala_2.12.tgz"
  mirror "https:archive.apache.orgdistflinkflink-1.20.0flink-1.20.0-bin-scala_2.12.tgz"
  version "1.20.0"
  sha256 "708fd544ccf9ddc0d4b192fe035797ce16de2c26f1d764c55907305efe140af0"
  license "Apache-2.0"
  head "https:github.comapacheflink.git", branch: "master"

  livecheck do
    url "https:flink.apache.orgdownloads"
    regex(href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "634c5f4048bd9d4512002ea98b7bc7411aee0331c5c0e6c934cd8e3b24d061fa"
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
    assert_path_exists testpath"result"
    result_files = Dir[testpath"result**"]
    assert_equal 1, result_files.length
    assert_equal expected, (testpathresult_files.first).read
  end
end