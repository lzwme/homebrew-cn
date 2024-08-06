class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.07.29.00.tar.gz"
  sha256 "facd624042adb0de1af631751970d2bbbcbb698068421e54551f78282566925a"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a972e811119318ad21ba1b68cb8a1ad20ba83ce82629e89726f14aeb76c6fc0"
    sha256 cellar: :any,                 arm64_ventura:  "77d19787418744a9fdbe7e06259190344b55a686007ba7e718a848eec232e75f"
    sha256 cellar: :any,                 arm64_monterey: "6d492e7dc95292009f6b49877b333e54a8289aa9efeb37ec70f22d9e8feeca7f"
    sha256 cellar: :any,                 sonoma:         "6b7f4ef0ac0221ddf4adf8a2caddecfa2bf52c49bb724016c2108e845119b954"
    sha256 cellar: :any,                 ventura:        "d0dca354964b57be12e7191aeefec58f42e2d95c09ac0f4221026274f81f79bc"
    sha256 cellar: :any,                 monterey:       "23a76be61b34022c9cc0f877653e21690dc67007a95c116da9a6dada6aa87fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e92588020d1eecda01c43d99350fa3bd79d5b80a0fa07360d9870f10c650101"
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