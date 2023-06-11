class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "78e62ed2c4fdfd4ec4c25aedab38951a06a2356b162b9c444743b61a7cf1105b"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c60dcbbf6f25b1c36fc04c2326b9e75c1595b2b487e2aae61962d370ecb9d300"
    sha256 cellar: :any,                 arm64_monterey: "a56ddfb07448605cb5dc923093a60b43e529b5b26d8d7d29b909c0dd87c4da9b"
    sha256 cellar: :any,                 arm64_big_sur:  "f40e4256645135ce6430ac32a39b1ec9a811091c1723c8ea18aaa5abe513959f"
    sha256 cellar: :any,                 ventura:        "56e26b4fb3c9dc940ff8f06769274c8cd8246ddedfad3fe705f3a7f8af548903"
    sha256 cellar: :any,                 monterey:       "710d7d11e43c037e9435b0a26dc1603b83fc126fb23afeb138c08e24995d4d93"
    sha256 cellar: :any,                 big_sur:        "87ec54a50446a0e96c06246866cf9bcf4d8785cd1b54dcb571ff27d46d744a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba2e463fd0bea6b9587ef2013b67244fd92af9df015cddf6bb3399c286ce8986"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end