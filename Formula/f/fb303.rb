class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2025.02.10.00.tar.gz"
  sha256 "7409cb710adb1fe21db4c70641f601a72068ce432f5eb13657171004cbf1e503"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68dd96beab44c4f232986d6e705b2fa6337fcf50c6a41ee7122a10f19d80e323"
    sha256 cellar: :any,                 arm64_sonoma:  "9aff2133fec20560e7912d0b43352472876d443f59534f3bde0c767cc0e0dc4b"
    sha256 cellar: :any,                 arm64_ventura: "c36fb049782e86c28050e0899f85592ca127df79e7535800a14c6273b692a4ee"
    sha256 cellar: :any,                 sonoma:        "5fb65b2369fa5f99f5397316cf43dba1b1ee8ae7b25002d64d72dafe1502f6f5"
    sha256 cellar: :any,                 ventura:       "4e4b7acbd07162ece2802fc2172739d67e7d7da88267c87ad6070d193cbfb878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71e5268efbe8a7e713cc750ab77a5d341dbae60eeae3c49cc35267ba076a8fd"
  end

  depends_on "cmake" => :build
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
    (testpath"test.cpp").write <<~CPP
      #include "fb303thriftgen-cpp2BaseService.h"
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