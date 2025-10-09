class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.65.0.tar.gz"
    sha256 "10ae39d8582bcbc3e3ed0cad1daa992150e779d07641b248fecd9ade2c48a5d0"

    # Java 25 support
    patch do
      url "https://github.com/flix/flix/commit/4df8a6dd7f28273951977de25bae073a2a02f2c4.patch?full_index=1"
      sha256 "1f71f5323e0de0d674008b2f1374ccb46f858d72ae8b740f659d9ca7facc9add"
    end
  end

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9d98b0af72af80dfb4b7c7e89a7b75cb777183b1ff71c51e08568f117072a2a"
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