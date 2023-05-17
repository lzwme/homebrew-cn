class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "8aba581414461149e5be21f2d7ee40f7e6c62922a23c73524bf2e7d677aac355"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69cfdf739d51fa0cebe450b4cee9c5a14ca6946f159d734c3f9f30a1d3d6b81b"
    sha256 cellar: :any,                 arm64_monterey: "ed706768d93cde9372c1c4753ecc484831c80058a33209a1237c79f1f653e4cc"
    sha256 cellar: :any,                 arm64_big_sur:  "985e299092759edfa4fa388a1bc2a096fba1babd2fdbbbd513985d69e53ea6dc"
    sha256 cellar: :any,                 ventura:        "a65f30c04c8342ec0af79e61161c916117327995474312ad6c34dc005a823307"
    sha256 cellar: :any,                 monterey:       "752c15a9a067010fbd876328ce117b8393d54dcfd1ec025f0980a6181c383bdb"
    sha256 cellar: :any,                 big_sur:        "59c7a32962c649dddc975d6c4d6e85c40da799bc2e4deca06c660feeb877c5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef340e896fe0cf95c1762a3d633de0f911dba2bfc87f6eb59d74d0e7dcd786d2"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end