class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.09.23.00.tar.gz"
  sha256 "abcabd8bb16a37dd27906148d31eb169ce7277bd5ffe16ed06d4335d09f8312b"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26d86755e1ef8af1ae8bb91365700cb41276a34c5c68dd5dc512689d11c52f07"
    sha256 cellar: :any,                 arm64_sonoma:  "72544b8c19a6a6a4d30ac91697645d49fa7d267109878affb88f58dec8167bb5"
    sha256 cellar: :any,                 arm64_ventura: "be51dd4cade750cd5b9ec20fe38559304b9effc662d41d51cae4653d64c5a9d7"
    sha256 cellar: :any,                 sonoma:        "08135f57e81ea71d7f234aee680eac7e8b79a0a0073e30fbca7078cd88d8edff"
    sha256 cellar: :any,                 ventura:       "96cde2814fe234c24d371ad0e25f35b440f5180c4e315990bc36292a2a57f2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74766732aafa5111784fcfc668c38c0485c169eb1890501933d13e21761a45c"
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
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end