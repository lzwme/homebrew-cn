class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https:flix.dev"
  url "https:github.comflixflixarchiverefstagsv0.57.1.tar.gz"
  sha256 "23396bb2747651661d3399e0f57e98785f235a89543a95074a892655184c521d"
  license "Apache-2.0"
  head "https:github.comflixflix.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5ff3c70766108139317956337613cb8a5395b747ce6cc69a16775c96e2dc432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685c0ee75217fab345cc40dddd4294ae1b0ebbc5640ebe2a1b57711a48e3e43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72cf4bee57af586aee7835e9db5334fc973b4fd92b2707563d8073f514e13de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc444222f88a8a6f64b2094805f5875aa31473d0848e76318eb0cb49c75b87c5"
    sha256 cellar: :any_skip_relocation, ventura:       "43f3f1e3bed69d83cb66890d417b9348ec6a8d03300bd5f121464f6aca20398c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f085dcb9bc31d38551a56a27e1c11e45e7d6be92fb144bd29e421b7a831c96b"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system Formula["gradle"].bin"gradle", "--no-daemon", "build", "jar"
    prefix.install "buildlibsflix-#{version}.jar"
    bin.write_jar_script prefix"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}flix test 2>&1")
  end
end