class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.09.01.00.tar.gz"
  sha256 "e8a96bf3a5469b836ee97d37a7a59c1473aaf8c1e29e14c2300b0ee674b344d0"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "a2e151d507e71bdd1d96a9c5a86ae2ad2bac5cb36bde61d71ab0bbeed3615477"
    sha256                               arm64_sonoma:  "724c220cc9443d0af4cfe9b1e3d5dc2a0a8033a1cb8a9d6b972e9a1611e4c63f"
    sha256                               arm64_ventura: "afd239f0b12420c324bc49da45a55eea3b41fdf15966acd5948a89d17ece483d"
    sha256 cellar: :any,                 sonoma:        "6aacbd64daeade83fd6716858063f2333dc2648ad40e7615f89a759b53a24dd3"
    sha256 cellar: :any,                 ventura:       "fa04536b41e742be627cd3a304a09aa31c64c704f1f0cea7f4bc5691e17af393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd981af655ba4877659d998861303dc0d3b24021032064b72505f8ae776eb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1cc9da6a0d8cd27cc1e6b9764a20146c6e37825b0d2d73650453c9c3b9c739"
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