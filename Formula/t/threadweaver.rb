class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  license "LGPL-2.0-or-later"

  stable do
    url "https://download.kde.org/stable/frameworks/5.114/threadweaver-5.114.0.tar.xz"
    sha256 "f0f5042c7c1cbf601ba1c1e0c8d487e942abba52e3c9367c08717cc3517907f8"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "55b2588a9fad79e10fe358ded618b04b8db7cc19968eadcf29942615cd0e42d2"
    sha256 cellar: :any,                 arm64_ventura:  "4adf7089c2ce9501d501b60bfec16fb39b4f816eeaf35a91d54e2c9ebc95bed7"
    sha256 cellar: :any,                 arm64_monterey: "f1749c19a4873334d9dca41277992546f32a3009ea8789b878a93cd45c7f25f6"
    sha256 cellar: :any,                 sonoma:         "4716960d66d31755b11416536ab1a3d979d87c91f1adac97cfba3e92de336682"
    sha256 cellar: :any,                 ventura:        "5e00843078ca1259f33e8f356c60f9a497653f8a72ecefe409fedfb4888fd748"
    sha256 cellar: :any,                 monterey:       "d9ee0029ed89d2c873cd87e4135a6a5a0d9f63e50fe969463ce1efc6f820601b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aceccf8ce12a6ae8c64e13f49d0e14d9e90588c2e2150ff50106658624ca5ce8"
  end

  head do
    url "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    qt5_args = ["-DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core"]
    qt5_args << "-DCMAKE_BUILD_RPATH=#{Formula["qt@5"].opt_lib};#{lib}" if OS.linux?
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, *qt5_args
    system "cmake", "--build", "."

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end