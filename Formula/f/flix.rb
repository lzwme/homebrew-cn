class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "9403cdc01f6957b89119ef9026f95fe024db04037a03b758506a3f65a79e5a77"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb7ba5143d1d92593406c5618cd3e5a9789f128ecafa1107d68c14ec8be64226"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "gradle", "--no-daemon", "build", "jar", "-x", "test"
    prefix.install "build/libs/flix.jar"
    bin.write_jar_script prefix/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end