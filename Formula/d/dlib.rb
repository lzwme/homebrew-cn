class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http:dlib.net"
  url "https:github.comdaviskingdlibarchiverefstagsv19.24.9.tar.gz"
  sha256 "65ff8debc3ffea84430bdd4992982082caf505404e16d986b7493c00f96f44e9"
  license "BSL-1.0"
  head "https:github.comdaviskingdlib.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d837ecfb66b6f9dcf3e3da883b3e0f1ba898dcc98d9a7ca1ec466b4e3574cd43"
    sha256 cellar: :any,                 arm64_sonoma:  "4e0d8452b3aefab4c2aa2b1aa86cca6527d8b2273bc9ece1c7f30e8f72098be3"
    sha256 cellar: :any,                 arm64_ventura: "267c714e2e908103d442163f2a9c1c3e07b5026bed843c20ac18376c12bf2071"
    sha256 cellar: :any,                 sonoma:        "17d127462b3a90968452527f849804c9d1f9793496bac0cff3baea46e96a0340"
    sha256 cellar: :any,                 ventura:       "15efa5a0d0cf21ea1f5593be6371731cab3ea7457e2dd98716114deb13f6d1ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c901a7c6e4001e0a455c88c99fac88f4041a474b599f64cd76daa756948b59d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81a4a177a3c24c9e26bc7c4b21348774eb2813897f76d56115e9a790d984756"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  def install
    args = %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_libshared_library("libopenblas")}
      -Dlapack_lib=#{Formula["openblas"].opt_libshared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DDLIB_LINK_WITH_SQLITE3=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if OS.mac? && MacOS.version.requires_sse4?
    end

    system "cmake", "-S", "dlib", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <dliblogger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    CPP
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(INFO.*example: The answer is 42, shell_output(".test"))
  end
end