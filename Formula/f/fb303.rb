class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.10.28.00.tar.gz"
  sha256 "522f4ba3eb8781c72eeb62896606be72d85753321bbe495903f3b8eed9c19253"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85bc3324e573bd178e1c12d1e59a0743d035a07d409e4f2a28dfacf9abbc0705"
    sha256 cellar: :any,                 arm64_sonoma:  "93c483677f171db1e78bb949616e413dd718da85069bc30d7e7cd6b96bb6eb78"
    sha256 cellar: :any,                 arm64_ventura: "70bfb47b6f0eb062a6d5de2bb4f1cb390b2f902af84d9a142eba1dfe35d0dce2"
    sha256 cellar: :any,                 sonoma:        "886df4cf31e29bcae2d58bf059f5839c52fc5d74ae42bf4b2f003ca6cd1f20e1"
    sha256 cellar: :any,                 ventura:       "ccd87482a90b6ca408af175af6a7d4d21598cf632c76f68714bf749776af7db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16df85a831a13d682ef61d1f9c244065e2c4a9f19396b28219bf10b2299b99dc"
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