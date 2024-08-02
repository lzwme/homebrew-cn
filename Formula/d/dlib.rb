class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http:dlib.net"
  url "https:github.comdaviskingdlibarchiverefstagsv19.24.5.tar.gz"
  sha256 "01cab8fb880cf4d1cb9c84cb74c6ce291a78c69f443dced5aa2a88fb20bdc3bd"
  license "BSL-1.0"
  head "https:github.comdaviskingdlib.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aa46d2a49ff65d58448141ade0a2949a5309c9b2ea2dfc7e2c5b90aa2f32b3cb"
    sha256 cellar: :any,                 arm64_ventura:  "b3edb05ef7a83a8072358866525b073d32bdba63757a61071d196f5ed9d461de"
    sha256 cellar: :any,                 arm64_monterey: "28e4a0efa4cb3654a8de23c4a3c43f6f1639a38c0bae85a9acd521e25d5be7ae"
    sha256 cellar: :any,                 sonoma:         "bb7115e98d49924d7021426289a7565ede5f461e0588033b9ad24112dbe594b2"
    sha256 cellar: :any,                 ventura:        "8c0413261f82a367c5de3fc51829110fa1e60598ee635518b6f9a4ab13f727b7"
    sha256 cellar: :any,                 monterey:       "bd6696e120b25af98553914fd0cb23b36bdef5715520169a103b21feb109c4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bed428c5816f49e4ac539b567de7d380a0a78db6d9ab0c3d84e855125a5bf1c"
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
    (testpath"test.cpp").write <<~EOS
      #include <dliblogger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    EOS
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(INFO.*example: The answer is 42, shell_output(".test"))
  end
end