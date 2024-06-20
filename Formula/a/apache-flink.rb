class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https:flink.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=flinkflink-1.19.1flink-1.19.1-bin-scala_2.12.tgz"
  mirror "https:archive.apache.orgdistflinkflink-1.19.1flink-1.19.1-bin-scala_2.12.tgz"
  version "1.19.1"
  sha256 "596169f3efca71d41932f03f92b589b137f7c1edfe2850117226d739e799bdce"
  license "Apache-2.0"
  head "https:github.comapacheflink.git", branch: "master"

  livecheck do
    url "https:flink.apache.orgdownloads"
    regex(href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, sonoma:         "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, ventura:        "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, monterey:       "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad88b00bff78ce4a347abfb4e93248aa8e27c2f58a235c790e6eb9b271a9896"
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