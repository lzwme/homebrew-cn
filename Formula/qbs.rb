class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.1.0/qbs-src-2.1.0.tar.gz"
  sha256 "99cb322120fb59116e21752e0bc3ae76f86a82419b7c82d5b9fdcee98d6e4135"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a17830dce426317f8a77e554f31db18ba8d1db639c8524fac4f09c7e841c49a8"
    sha256 cellar: :any,                 arm64_monterey: "d4b19a00a0bbf490e24b126a664b6c6d69e947f8600a0d52fa5e9fbf9eef4821"
    sha256 cellar: :any,                 arm64_big_sur:  "6890c1649501f29be988e64eb4839bd2b59a6dfc8721bae4747e09a627447bf0"
    sha256                               ventura:        "fab79cea2906767cb04320f45d0497a53ff6059320a100d56220833f3883975d"
    sha256                               monterey:       "b5947c8364c07b6ce9bc2694d29fe629572536500af3ab6e4d895537b6c6f3d8"
    sha256                               big_sur:        "8c49d3e38d83b08dd251f9ff9812028be4771f7e79463fc9ded9445d9391fa66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2214880b4413c4a7d250b26ed96f5113886b02796d4bda0239601961c87e57"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
    qt = Formula["qt"].opt_prefix
    system "cmake", ".", "-DQt6_DIR=#{qt}/lib/cmake/Qt6", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end