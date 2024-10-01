class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.09.30.00.tar.gz"
  sha256 "1689506cd243c3f20d18b18472b19f91ca8c4bcc4b41939b3bc06194aad38025"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "541d71d3901f6532e67aced500fc35d306f9d271ea0e481388cca54b88c94c03"
    sha256 cellar: :any,                 arm64_sonoma:  "c38fc6440e28b567530125269dc5ca25fdb43a07fccc46d0480e9e3342ed15a5"
    sha256 cellar: :any,                 arm64_ventura: "0afe8704b0761ee0f7c82df67ebda795475cfa10cf3595f124494a17e0026170"
    sha256 cellar: :any,                 sonoma:        "4623c75c3c6c2ac945f14f4519554671929c49eed1544cf728bd2e5c23e4ecf6"
    sha256 cellar: :any,                 ventura:       "e7fc267fba1a4e6bbea24680381f816bb0d8bf558d16440812e8ad14f41fcd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92eef87ba49555ed510bfc834a51c460caa643abd8b25b86d13c3c55e97a433"
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