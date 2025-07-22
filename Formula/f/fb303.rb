class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.07.21.00.tar.gz"
  sha256 "f25d9720c145a22aba5089a72ad7a4a0be7facf34a7b39a5149929f94ecaff0d"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "4ff8d6df8e51b47babd8bf47237444af4391f08933b3bd5a263f3f8ec25c4e16"
    sha256                               arm64_sonoma:  "77db90b66a10a9caa825f46768cb3ac6c374a4773b6c734a736f5937ef87cf49"
    sha256                               arm64_ventura: "437c84d13b2160c0d7993fc1b297f08527df0ba676d7437b1f9908002e911f29"
    sha256 cellar: :any,                 sonoma:        "c87dc65b98a37bd6113276624eee491856f9f4119690b56b761e581777398b4d"
    sha256 cellar: :any,                 ventura:       "a726493d638ee55f9e2ce34cab4fca1975d2ebe32045e2f6485a8648e0695354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c78083638feb665af9fbe1141cfe75f760aead731c64b4bd6c6237f5f4fcad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2da2f1e790df2f5d79b286e7489e4b9fc9b2177f9b3a15ec5a15e35cb3a0a1"
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

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end