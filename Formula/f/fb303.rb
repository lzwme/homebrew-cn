class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.12.15.00.tar.gz"
  sha256 "7cc5771385da677fac8566cb8ace5a08f017e4db8fb1967e575889e58360ce99"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "9da3af47f565cfb34ce40652059fb696ff62a6210111bdb63c596452a377b3ff"
    sha256                               arm64_sequoia: "5743eec3c8cc456e600108884217b51fa0151efa3811bd00212fc9aeed27a2b0"
    sha256                               arm64_sonoma:  "d8c3f9cc21ff59b595b96b95e6ebf0e3ab3f9b3aa012d68ac33efa9dc0adf4c4"
    sha256 cellar: :any,                 sonoma:        "919fb352e1e1a9c8288d80b421090103632bccc933c10fcc93a56a58694d84d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07f0115007fdc494286eca80e6578cd244700411f771e59fcae706e9cc933677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d118f4fc1a4382e2f3d200197e09dfcdee8ec7261daa6055c1b96f5f20dc510"
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