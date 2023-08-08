class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.08.07.00.tar.gz"
  sha256 "bc320c5dbe33e85aece44b2aaaa00f024c3ffdf4b58eea0a543f2460807887a5"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9957d46547e01f20ba77d449b1303440db2ac356ef5a662f3fa0a92989f3f469"
    sha256 cellar: :any,                 arm64_monterey: "899e8928ac63a15ddb2a6cca1c5ae73e6b496e3cecc93a536ad7ba737fc61090"
    sha256 cellar: :any,                 arm64_big_sur:  "90c6ae74d49dea887504cfbe905888727115bb48e26c0e011fdfe1b65a3ab40e"
    sha256 cellar: :any,                 ventura:        "270a9c0a1d6b0a134ce7d6e1ba8197f8a6fdea2f2f3086984378f4d6d1c2b340"
    sha256 cellar: :any,                 monterey:       "5e94f8b91ed3ba01e6aba6a15dab50164a5a29bcc0652f60f4b67db7887854c7"
    sha256 cellar: :any,                 big_sur:        "47cda86eb1f1791b86491d8becf6efd147f0117a85fa94e9c4e14f9461f9ae9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6de1ac321d13e82e49c3dc88bb63932cd5233c5eb338ef655249c49be409983e"
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
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
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
    assert_equal "BaseService", shell_output("./test").strip
  end
end