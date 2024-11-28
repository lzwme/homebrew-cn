class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.11.25.00.tar.gz"
  sha256 "fdcd9062516431e30585eacfb452aa693de1da172245bd29b4789b3328458e11"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdefd17b8db77b52482ca0cb24926d3512349258b49c41e77fd9f37d397bfc28"
    sha256 cellar: :any,                 arm64_sonoma:  "3958bd85013a93ac4e69dd31bf6db23f11555e39bd97bf8541845d8303147d4a"
    sha256 cellar: :any,                 arm64_ventura: "684e8f63e9bab16d2743becc588b4d899778defb976e754bd663f9fe31c2e95d"
    sha256 cellar: :any,                 sonoma:        "7127ff7e5a7802dc672a737af24a3ccc198befc64bcc6d682197e19b5ec04c31"
    sha256 cellar: :any,                 ventura:       "e729de8951ef09482e8bc282e7d7a3471a97d0d7b0738d315ce64045de351e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9aa6af510ccd543cf3bdca3c26a989740da00743450960cd9c19fdf2b895dd9"
  end

  depends_on "cmake" => :build
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