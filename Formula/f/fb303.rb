class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.11.18.00.tar.gz"
  sha256 "f5f606e6e60641ae781b5cf75bf4a15a0ee3dbe189668e71eda80e4afa949704"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbc472a56041356b37944a69189dbe2f637f30902b34c7c030d63a15985303e6"
    sha256 cellar: :any,                 arm64_sonoma:  "d04de0b8578e48dc8061ad05b17cdf9f09833e24c5c891b9c16d85e11d0d3a19"
    sha256 cellar: :any,                 arm64_ventura: "87dce6c4c56a133b5b9a628052a73590432dc4097cb91d03f9cae75bb50866c0"
    sha256 cellar: :any,                 sonoma:        "a0783d8df728efb266bafe745277cfd92d1dad25449c9ed9b373ba8f4e26b262"
    sha256 cellar: :any,                 ventura:       "ea329e7f1cb21f581a3cdf53af20ee1679c5543c4f42a59332da5d55b52a6b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30b4e0e4f80dc44293931a20f406828f8f005265d94250d4b42fc61c890d90e2"
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