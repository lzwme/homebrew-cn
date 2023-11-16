class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.11.13.00.tar.gz"
  sha256 "c7702c8987f2133f8311688ec3afe1ea631431d72329e96781f627c3ce404ebb"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a1279e8d41031a0a4d89d70478c6d44e28c334cc92a89c22007fbb0b2dc07cdc"
    sha256 cellar: :any,                 arm64_ventura:  "f753771afb69b3dd2db1b1df3d2b4202b2be2f0b8424cccb0969f9ba189b84f2"
    sha256 cellar: :any,                 arm64_monterey: "b5d6bff1c75262dc6e472e26bde5a901953107b03a3c015b8c42e37acefd44b9"
    sha256 cellar: :any,                 sonoma:         "752d2e3db47a6c43525baa1e602eef94e935f8caceda826ba6276f138f905155"
    sha256 cellar: :any,                 ventura:        "d9be21e0dcf94dbd0a98233ded9028a3ea8a849505bd63ff3751d36be1654659"
    sha256 cellar: :any,                 monterey:       "6b3ee8703705f3798dcf2845eefcd6802cb044ea143943c26b589ab9c8f2228f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bf7395c0cad54e36a3b967f97d66be7bafa6133ed7c85cc17064e0725f5f029"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
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
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end