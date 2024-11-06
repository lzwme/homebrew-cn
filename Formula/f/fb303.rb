class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.11.04.00.tar.gz"
  sha256 "6003d61f184a41dbac3642870d9479d7d43152b68d44758a478ce8da3f1dcea5"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e64f8d3a5b54f6a2f89bbe0033a99c0dfc03b85f8feb1e78ae5abca349621996"
    sha256 cellar: :any,                 arm64_sonoma:  "681ccda630f51b0bff1c7ac59fb08618bb9fc5f2010f0b3674a4a82a163ef949"
    sha256 cellar: :any,                 arm64_ventura: "e3ae77b115810589015057816163789960f3dd22a25d4ad675213663d45ba51c"
    sha256 cellar: :any,                 sonoma:        "8c183b421130e8f93101382a2be1d27bb59b1e4791ed4f9d3f3d41fcfdaea147"
    sha256 cellar: :any,                 ventura:       "9eb95608e761d2d9b6f862fbb27a43b625a781f2f0446f3143771ff6799faf56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb8152557db35c7bb5332916eddea7216cdb2a93cf8e39e364e3284ec4817f0b"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

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