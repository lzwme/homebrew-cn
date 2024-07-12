class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.07.08.00.tar.gz"
  sha256 "8eed694dbd54de87cea60634111061d4d7284a4cdf920ec3366516120385290a"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c199f8b3a8f9c458ffea1417e7f2c92cba24efb871b7134bf32d14864c4aac0e"
    sha256 cellar: :any,                 arm64_ventura:  "1107eb4c6aff820d76850809de74d4d64637b82a16b2de58c34a011317a474a6"
    sha256 cellar: :any,                 arm64_monterey: "47089bff633d1f44277d53ea2c6b8d517da793eccdc251c0a8d0b2bc5ecc9d68"
    sha256 cellar: :any,                 sonoma:         "ec27aadb7bd70b5a5bf232e52c49840510f5faaf5ffd239c335effaa8b41cfa3"
    sha256 cellar: :any,                 ventura:        "3eb1d4063c9bdcb1e9b2b877043cbf8801b00e9e2990a48a918092ae689ead78"
    sha256 cellar: :any,                 monterey:       "ea0e60ed4984fc613f9e3067e08c6d7df5f7b56f4fd8a50766f31d3273bd9ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33dd3179b40878f2dec024bf8db79fe9d2a82b8667f1b1f91da56f6e8af09ad"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "fb303thriftgen-cpp2BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end