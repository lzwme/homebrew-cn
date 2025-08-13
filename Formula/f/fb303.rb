class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "69123178f5e00c0a507a82dc5cd33ff81300ee3a50d7951425d9f5931ee8fbbd"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "a9360d15d4497e36c188de3b85529a1b6ad33922516db3be41560da1583ac9cd"
    sha256                               arm64_sonoma:  "09cd1df8ec18e72080b7021a1b664e00b2b26d7c1b0aef094466d965c6c42b42"
    sha256                               arm64_ventura: "a8dfbb1ca7004c49c4fff1b4bbbf7fec11e79c7bb4cb767abe36905eefa057d1"
    sha256 cellar: :any,                 sonoma:        "037be4de7b87f8b648a4b59964bfdf205982e526b3e9ee54fe314fbedeb0703d"
    sha256 cellar: :any,                 ventura:       "de0f81ba39281a2b53c26e294b3b637d37dc56575229c30e51c7cd4ed3431c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13db6cbb0bfbf5cff157b0d48768a0c399d04f65e92bfdf7670bfcb58e4b5567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119e7a1b6d82e1d3c01766a60d8126d117f3d2d586a93335a90ca8324d027e70"
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

  # CMAKE_CXX_STANDARD to 20, should remove in next release
  patch do
    url "https://github.com/facebook/fb303/commit/ac1a8c3fb522f8a08d96ba831818912e18d565d9.patch?full_index=1"
    sha256 "f048ae3b053822114fd692967cf7b8e8f0b362711699e65007c406b31d67550f"
  end

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