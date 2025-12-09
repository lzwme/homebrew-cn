class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "4edb02ef25543fa94741f3478666fb08f18fc3e22892c6c406fd041df8315f94"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "6b27c5f40a25a21587008e9595e1991ab1f1b4ad64082d29d14f0187a2ff2613"
    sha256                               arm64_sequoia: "923f0a4933b15aa2bb3aafe5b4d0ae9f80a36b6d8aeb0579bd191e3866bd7eeb"
    sha256                               arm64_sonoma:  "aaa09a9c35e7b61af01bc92428502048c55a24a4fcd0d7c5943c0a7bc33ac72d"
    sha256 cellar: :any,                 sonoma:        "9d641b32d8ae0866f95b10c2bee90b117adbe136f1a155a580ac1f1a7ac30c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "718e0796483eabf8bf3b7b857b664feb14ac0e87852b7f981c8bb139728363c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d8ac0498f70bce33a86702531685cceb14c6e9dcd7cbe18c3158ec9321f1fc"
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