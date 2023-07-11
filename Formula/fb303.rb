class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "0293859ce7727a8357ee1c98a552a0889cfec4865a1bbc81d71ef8442f53b769"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c40138fb0eafe080e19fff63484db35155532eaffbd3e6f731eb3519d222a87"
    sha256 cellar: :any,                 arm64_monterey: "55343e4f4fbb5a764b49c9b80e9ab3153a5746002ecb723d3ed35a24385b33bf"
    sha256 cellar: :any,                 arm64_big_sur:  "6f8e9e75e03efb38697f1ee3deb561814de8db8be8bec5526ab8f557f3cb6754"
    sha256 cellar: :any,                 ventura:        "bb746f71143eede66fa678469b726c64ec8dba3c38646339c811110aa6d0aa39"
    sha256 cellar: :any,                 monterey:       "712467f24a86bbd5bd3f1b828c6c62de474245c2cea0e1f7b7148e67cd9e48a8"
    sha256 cellar: :any,                 big_sur:        "2f7e3d0f11e62454face0e859075f83bb5809f3c060a5e7fd0f33d573037b90b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9516862274de12f0ea4e8e4bc7ebb7b1d63a46fde444432f58a7e7298439ac5e"
  end

  depends_on "cmake" => :build
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