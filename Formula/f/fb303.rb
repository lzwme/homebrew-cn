class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2025.04.14.00.tar.gz"
  sha256 "abc733953f513bd47c18313dc6996f7ed42ee264a74ea1a9d2e5fd08a222137f"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "1253a79ea90d4ce61028ffa1e86b6bacfe1c7a8c84f9b3af7f71f1dd0b435485"
    sha256                               arm64_sonoma:  "4ec6f5e5248e2c9668c02fbb7558086573a7e90704bd2e9debc39513844a6a93"
    sha256                               arm64_ventura: "8bed7326f7c98af8fc874dcba6a58b84e0e81400e893273557cb1bf765e0accb"
    sha256 cellar: :any,                 sonoma:        "395c09480dccf69d6d334af1088fe28d339f07bfc3827bacae3dfa7c66aa6760"
    sha256 cellar: :any,                 ventura:       "4b539956c83b521709fe15ce25d9d5e773891beddf99dd08ce1b1401a703b079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021b3a4ad2a6e4fc390fcea7ed54b97def1a15f99e804b55980ef0ce75091a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6996dccf816af9fe7ab14702bc00a7880ae64ea145445cb55f64982cf1493032"
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