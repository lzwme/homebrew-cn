class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.11.03.00.tar.gz"
  sha256 "a57771da781be85bcfe6a187151b6f178f9dcc8be72cb55c6d9f136f7d388e83"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "f95847d75126d7087b83c31bbceafd061eca1a8131980416e8e361f47c0e380c"
    sha256                               arm64_sequoia: "3c0c6802780f7aaa7af18c741b014513b72a902f5b1c8ba96da417202241027f"
    sha256                               arm64_sonoma:  "bd7f9d50895f887d5c01dee4987a6b02e5efc1edc12149c7b27381ec06d7def9"
    sha256 cellar: :any,                 sonoma:        "7fe09b76f2498aafac49069003b01c57db7d9ba867fb657b6adf82227853e786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d3c13fb671ca42e54b6476599ebd4e1cae2f5ebb8f4e34bb70925fb02bfc41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bccf91301a2b2a019c51dbcb641dc41ab8ec6fbde4c108a56d55b61cd2f8cd04"
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