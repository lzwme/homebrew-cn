class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.11.11.00.tar.gz"
  sha256 "75b6bbe9aa109edfa3d7845370f11e0bcd0be705ea81861fe386c663db3a7ad4"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a11e63c824e418d210d7fb5051be1bfc53ad2c0a49285b27f670145d4d0227d"
    sha256 cellar: :any,                 arm64_sonoma:  "4e9f006e06f99f2cc02795cd6ed4e10e05e4e0718cf1b7cca41f921f756ddb7d"
    sha256 cellar: :any,                 arm64_ventura: "53107fc77966f397ba4dfe64e0ece3e0e4f972904bbb1cfc927ce06f38ae9e16"
    sha256 cellar: :any,                 sonoma:        "6b8653748665a1b8df95ccdc1858fff52c3b80c55278c52c459c44a72ef33e67"
    sha256 cellar: :any,                 ventura:       "34361b9e954b901f6413cc76f6ce1d02bcddc884287181700d066ea6f3e7c8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76003d9a3ab4897aafea218f8f568813b7b8d2519f6f6733f72f033cf99fe009"
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