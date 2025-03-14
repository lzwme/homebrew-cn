class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.6.0/qbs-src-2.6.0.tar.gz"
  sha256 "9eac7441a5c80df38190796012a842d0d22b0f3b11845d59c5d98b4e88457f02"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only"] },
    { any_of: ["LGPL-3.0-only", "LGPL-2.1-only" => { with: "Qt-LGPL-exception-1.1" }] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
  ]
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "ecf80ccf08832360e1e80c2aa550d917438a4a068e5033e3c20379f2260be485"
    sha256 cellar: :any,                 arm64_ventura: "ba73083d54ee2e7dca9e5426cd0b644fbf5a4f7f11c1d55fca32dcdf00e103f7"
    sha256 cellar: :any,                 sonoma:        "df65d6a290f11846512605e8a2b3e9baeb51fd57457ab58b6b690dce4297fbcc"
    sha256 cellar: :any,                 ventura:       "f41a9f59182e39c946124adeed801fc6c43d67c47a619ad9bfbb11c8995a9fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90bc36ef68d4bc42aaa8615710f36ed6eca1b7a9cb4e1fe67e46b1b316f125e"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    qt_dir = Formula["qt"].opt_lib/"cmake/Qt6"

    args = %W[
      -DQt6_DIR=#{qt_dir}
      -DQBS_ENABLE_RPATH=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end