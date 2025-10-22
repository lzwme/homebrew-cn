class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.10.20.00.tar.gz"
  sha256 "4afc7b4f85c77a022e94e32a9edd78be340aab8e98731c2dbafb3f21378734fc"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "566cc719a38f71fe689dee26f5bdd107e75efc601c357c9aebb7daf5fe01c52d"
    sha256                               arm64_sequoia: "00685938d69b600c0455aeda22f0df344bb7698d275b03d7ef5756d3f4e6edc2"
    sha256                               arm64_sonoma:  "167eb2bec1ff0fc908fe2b80d603e5f854a2e2d11f4706316183a32b743afc81"
    sha256 cellar: :any,                 sonoma:        "fb19cee3feb1ed04fd794a97cae1fab8cd7c642406855197ca1c2490bdcdd890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78f86358f02a3d9e1b5fee86989cf7b3a57e5128e933ac02d82c2a800ada91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f962896faa1e0dba567d5b8c6ad74901e28c4c731523ecbc9ecd7926b65e206"
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