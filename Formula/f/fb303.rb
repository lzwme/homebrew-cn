class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2026.01.05.00.tar.gz"
  sha256 "467219abcfffa39bd50d2893ef0345c242b709a49782a5080ee933c6c652b5cb"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "782cf36178ff286f635ced00d7b0631f8d2c1244d80542d0bfa19d4d3e84dbdc"
    sha256                               arm64_sequoia: "526a3968425c50824d083213a13edd94c20ffc9c4ce49507390202a74d6dc675"
    sha256                               arm64_sonoma:  "37fb156b2230f35b93497ce892b8dbb86917cf0e297b49821fe5cb75605c6aa7"
    sha256 cellar: :any,                 sonoma:        "6769e492ca61575c5cba52601361cbe71b84d14b6a40e2b052f5f591f4596bc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b3ed22afd92a2251af3a1eaabb98ca7ac49f120232cd67e10824ca596f0159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b90013661682e094a6ed3aa1e6e75d3ce5186f3507fe7dc32d293042998b860"
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
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
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

    ENV.append "CXXFLAGS", "-std=c++20"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-lthriftmetadata", "-lthrifttyperep", "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end