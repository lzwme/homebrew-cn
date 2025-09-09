class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.09.08.00.tar.gz"
  sha256 "986072ea576919a9fd725cc61141cf6012050458ed613104ddfddc5be967de47"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "dba8f6c9bb0eba9b8c9749d1c1b1b74b45ca39a0432f4a1a6c936cc6ccc06a0a"
    sha256                               arm64_sonoma:  "a7bff545e2ef55e76c819893f5911a06da944416618c36948d9ebff1cd019921"
    sha256                               arm64_ventura: "06b01e72f1952e5677f09b7dfa25d7c08e3e53533ffa891a3d0c801308ffdcf7"
    sha256 cellar: :any,                 sonoma:        "e8e62144808f5db65e35bb5a5a40c34fe1c2371dfde0aa75903a0b4fb81716fa"
    sha256 cellar: :any,                 ventura:       "e62069c208eb89c48824cf032b10e473c71723cd5caa508a9ac4f7f4250ca767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be8a777d6a8e83b9aac9f1f4b836049c374858c5f877240175da9901eab88541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c3d6e0353dc9ace1df6eea723a476ea998d919d33a16f0ab94e58b2b22d831"
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
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end