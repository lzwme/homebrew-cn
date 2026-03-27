class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "f44fc3e9049cf08d3240d83a56eaf371aff9caa4ca2ae19d0e623fcc927956cf"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb4140a4dbffd835ce80b97481afa0308b337f867364fff32e6a75bc3c940317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db6c317903013837a3001280a4f67148eedc1c216c7857a6619b29355f20d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec2baecd4104608560b62850f1dd5c86e8da14516a244fc8c4a9e3fd2b795df7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3ec4e0c2ec5f854ef1474b5ee4daeb9efc7b96b74d32c35993a86cba400900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17fb0a8b12a308e947fe6dc408178ec5813022bbfa2d4ad5c75def4e06ea591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a2ae8df19a82b4409169a8e418c940a13b5fb65bf3bdc8a8eaf11101f4c1ad"
  end

  depends_on "mill" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mill", "--no-daemon", "flix.compile"
    system "mill", "--no-daemon", "flix.assembly"
    libexec.install "out/flix/assembly.dest/out.jar" => "flix.jar"
    bin.write_jar_script libexec/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end