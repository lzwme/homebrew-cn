class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.10.27.00.tar.gz"
  sha256 "f4153c508c91330fe720341037f8c95bb5ca744f69b903e1e3a2b6e3a250eff9"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "e2cd933495c5c8a7e1a78880d99ccb1e8460f7750d3ba12818902e8635017a7b"
    sha256                               arm64_sequoia: "41af14b4234058b9740990b620512b643c8e73091715370720684e8b7175bff6"
    sha256                               arm64_sonoma:  "03d847e8a5844281a6bccb136a6a75bcd725164cf70d91d11a4b03459036eeec"
    sha256 cellar: :any,                 sonoma:        "34e906a38b04f6f1bda2b49aa0ebbfb1b76c7cbe4f84efb547b049abb1d116ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbd211aa192675a99ec3e526062aa460b01e06562b4c37c33d6d6de68cd8026e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04b3663721c3f26aff01a63287cf7f437b386e6853133d1e41a35f9d694ae85"
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
                    "-lthriftmetadata", "-lthrifttyperep", "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end