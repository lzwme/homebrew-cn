class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.10.27.00.tar.gz"
  sha256 "f4153c508c91330fe720341037f8c95bb5ca744f69b903e1e3a2b6e3a250eff9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "63b7b4649494c3698428ba1bbe4d2250df57fc13a28c790163ae4acdaa044029"
    sha256                               arm64_sequoia: "a68dd4e3a491acba7bef54c8081a24af472c6816f3eb5aca9f5179150b108069"
    sha256                               arm64_sonoma:  "77dc5be422f50a584d7827ca19e425ca13053d97cdfc66f5164a77134d933ec4"
    sha256 cellar: :any,                 sonoma:        "9d7c8f7e018c1fe5a6ba5bec894229a089d5d0220d489550cfd09a5ddb1c47a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f76fd0e5064ea01f6fac1838c959325e068aab1a1166598405f44eca05c4f5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770ba90d81b2df65cce6def22a62b8bddbcae669dc5fa3417e2d581ad80f42e1"
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