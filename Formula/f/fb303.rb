class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.08.04.00.tar.gz"
  sha256 "15476f7de72f0270ac43626c1b50f7dabbf131e5939ba284a11797ad71b0ceab"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "da2a78192bd4ff337659d4f4fa4981d712e4daa1f4071b6552571d40547837d1"
    sha256                               arm64_sonoma:  "49ef6fa642c1180ba035eed88b58f7a6ce9aee6b9a17a9c0d56dcddf014d7700"
    sha256                               arm64_ventura: "560e3b43fcaaa441c277d40054c4e43fee8832959f8e5243171a3b49019de271"
    sha256 cellar: :any,                 sonoma:        "bcb0dd86272e5a7133d866bc9ec71344edf059a5ba73f8526399aa054ac0d388"
    sha256 cellar: :any,                 ventura:       "c569da331f72a6b2a5b93c33e288a0138415e1423b6de58340bf52b392fb05f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc227e14f6ede04c85259f711ba890d130e8e5703ed70f7e0e4219e43d9eb45e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d56e7862cf3ec83a35db21f9140986ca26514f919c64f0c49f3c8f77e78c0b"
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