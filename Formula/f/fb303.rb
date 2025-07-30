class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.07.28.00.tar.gz"
  sha256 "7c12d68c1921ccfcab43ed9ae5dc465df92d115a28017c211097731f2618b057"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "2960a3d7ae2e8a6a39ae82c7b30c8f0dd237b00486ff92af0abc0edea4ca86bc"
    sha256                               arm64_sonoma:  "d885ae34b38c7c6bf91bf2c5cda1ef0348508f6df2237d9862f61254ec8aad5d"
    sha256                               arm64_ventura: "113fb262704a9d361c1c90cf05bc68a15addeb5a8846c4010ef7b4c80ecf887a"
    sha256 cellar: :any,                 sonoma:        "09a9da05ac228adc5d369f12cdb32340d990dfc6c605e0e11d46964536362d78"
    sha256 cellar: :any,                 ventura:       "5976442c26e1899d6c33d22231afa67d479e7eadf05f695d8f916f956cdde3ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b35929424b36b62acc999f3ca7b853fa0f8e62b7b5ef4fecdda53a3f89430cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e10c692de3e68ec727eedfad369c4335644aba1fe7865268a63de8b55c3d932"
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