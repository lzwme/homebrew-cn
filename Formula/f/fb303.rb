class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.08.26.00.tar.gz"
  sha256 "5fdca6ac4bab1c2ee3bea7157a0d9e5b890c55e945b4dfdec86511f3671275a9"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "239dec9272405b43eecacd83dc7ce6a40c16decb620d33d5b49b4b0badcfe456"
    sha256 cellar: :any,                 arm64_ventura:  "57d2ccd82ee07c26175ce754953d6249aea29701820c342e43e427f2f706d75a"
    sha256 cellar: :any,                 arm64_monterey: "5d1fd6b7bdda311f4df43975fe54288cc14c83e7036aaa5dfbaa7ba719afd4fa"
    sha256 cellar: :any,                 sonoma:         "cd3dd0e1d312a353945f56c0c89c14dcb4654a4998a8016dbd5a3fda72233a3d"
    sha256 cellar: :any,                 ventura:        "76fb33057786cc1a8fbfc13d92107c1ae9ceb42d9d6b4c42b96286b45c9d86b1"
    sha256 cellar: :any,                 monterey:       "052fbeca019503a0ef4dfb313f61db58802d3e4f23876e1d3cfa8eda73c68aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b094c5064c80fda9777a9a0a861d99cb0c23ac8871cf05cc2bcc7505d577f431"
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
    (testpath"test.cpp").write <<~EOS
      #include "fb303thriftgen-cpp2BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

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