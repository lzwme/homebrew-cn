class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2025.05.19.00.tar.gz"
  sha256 "860d4589886265b7a280c8a9b8ba0acd21717b1f1c94d5b28fc0e535fbf356b2"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "6da909ba87e01a675b5b465089576c55d6d9eb69bc098187050fb291720a5a76"
    sha256                               arm64_sonoma:  "2c0c56343feda4bc355e7367a23603c822d41b6d53a4ac0672919b7f07de5021"
    sha256                               arm64_ventura: "2188d413283c4fffe1326ef3053f304bdec22eca43cbcd9cb88d18bdb1da3c8c"
    sha256 cellar: :any,                 sonoma:        "cd9879b6cca16bd930630613bf1a5ae6b732b573dfa5557810ce148cd94c6888"
    sha256 cellar: :any,                 ventura:       "f00c78b7da75405f024cc4c25445eb1025eb1011ab1412597f47e76a6666664d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c3034426d670c146870374992575e520e50d2be3e93b39893b909758b86f8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de532adc81631ef833e8d743819f52df5532bf4c63a4c29cc5370757211b6df3"
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