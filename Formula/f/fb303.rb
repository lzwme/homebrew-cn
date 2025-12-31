class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.12.29.00.tar.gz"
  sha256 "6c67a42b1b084af7468c5e511c8b337674f6d581338dafe1cfd65023ca244f7e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "c6e2c94236c6387b7d4c51d2b7168a28dedf8e5d86090c04ddfb8752be8f020a"
    sha256                               arm64_sequoia: "37df64310b9ab369c93accfb176b13add04113f8015f53c5289dacc6d747a787"
    sha256                               arm64_sonoma:  "1d8181ac3c5a5957aee3ab92e164f7e27b8930eb81705f593238e85f7f2a8db0"
    sha256 cellar: :any,                 sonoma:        "b7c5de9ace739dbc4df4febc53b29d5024bb504d7bb6cd09d98b6fd5847ba429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc5a37da945cb8b471eff589ddd609796788e167efc4d67a8de5a4ad9c45a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e2048a33a754ad210b3cb0421e8f120627de82d6abae5a5898ad462bbdc5c72"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++20"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-lthriftmetadata", "-lthrifttyperep", "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end