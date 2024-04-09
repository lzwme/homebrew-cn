class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.04.08.00.tar.gz"
  sha256 "d3913610db26312e4c212dd8f7eeb6ee6780a2176152834156642105aa740669"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b218f608ed20ef670e2b3068d77cc1875e5ef6c39d9a71af7caa0d9097a793c6"
    sha256 cellar: :any,                 arm64_ventura:  "9245539cf9ca5e7f976577e111bf9d934e148c95ca0c86d339ad9d207af1196c"
    sha256 cellar: :any,                 arm64_monterey: "a0aa6fa452330af2308e2f247c45016a5e19841e59b10e8c0f90cff34067239f"
    sha256 cellar: :any,                 sonoma:         "dd8947a60140358a6b17ce01032ec4a79f5aee52dff07e211bde0e1a12f0210f"
    sha256 cellar: :any,                 ventura:        "edba009f7501fc1a6371414875aea143c47369c0ec0ab97af1d397de51cd702a"
    sha256 cellar: :any,                 monterey:       "53c5efbbb98dd8c143f6f79a26e31cdee7c7283618dcaca218b5458077174fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a391291e59417a36529f99751c0d6a03adc3ab8469af227bf75d3c4a43d23050"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end