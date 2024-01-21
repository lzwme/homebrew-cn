class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.01.15.00.tar.gz"
  sha256 "b4579e89f3c36af062945bd31ae2b2ad69b3c921ca87b83154a5d8f7aa4d6455"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e8fa75fbd8777599643dc3f256f4bf1ea8d3e0b3f654fa3f1b5bccf0f04a959"
    sha256 cellar: :any,                 arm64_ventura:  "fad38d938be7fa7eec206d5fb394ead056fa626a04ba9f6246f780b5f68665b7"
    sha256 cellar: :any,                 arm64_monterey: "0f2b9ce74b5b85339f03dcb0a1e14d6cb507081594555e948038867efc40be55"
    sha256 cellar: :any,                 sonoma:         "b90e351418d3ad2cfcea8dee9b0589ee9ad4c299c10a8a74efd6771aa3db9a28"
    sha256 cellar: :any,                 ventura:        "77fb1804a5e29f31e2f617ed726f587e3e670619d95bcbd8830033030d4fa38d"
    sha256 cellar: :any,                 monterey:       "f8a2a03329ee06648398e1060c7a5817dffe320fc008509b9077d7fb09df5b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a02a2618973488ffed276fe755e16d3b03fcf72baa1795f181323b4986d1321"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
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