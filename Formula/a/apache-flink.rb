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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34232626d2de3280d92145dc48d802a5c3b61d9976246b67a761440df234f917"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34232626d2de3280d92145dc48d802a5c3b61d9976246b67a761440df234f917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34232626d2de3280d92145dc48d802a5c3b61d9976246b67a761440df234f917"
    sha256 cellar: :any_skip_relocation, sonoma:         "34232626d2de3280d92145dc48d802a5c3b61d9976246b67a761440df234f917"
    sha256 cellar: :any_skip_relocation, ventura:        "34232626d2de3280d92145dc48d802a5c3b61d9976246b67a761440df234f917"
    sha256 cellar: :any_skip_relocation, monterey:       "34232626d2de3280d92145dc48d802a5c3b61d9976246b67a761440df234f917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdee41deca5c4fc6953a49b81005e4fc5da3dbc230012f34490f53fdeea80a20"
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