class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.09.16.00.tar.gz"
  sha256 "4367bbec21916de85b1cfe4bac3f1496c99f4dd0877e275824c3ede8814ae655"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17265347d57ea3950fdcbaca53afb320eb56aee4007a354545a8b3fc13d16087"
    sha256 cellar: :any,                 arm64_sonoma:  "3e2866d390be0f829a4f8403f209ebdbf42f92844ab9050cfbd082bb568f8937"
    sha256 cellar: :any,                 arm64_ventura: "9a054692a1560a8a85fddbe9e5c9d679004349ee72131eba11ca723c54003ae5"
    sha256 cellar: :any,                 sonoma:        "c2fb12808d6353720f668b453da5b284b99e047620a26a68b0a4025f4a6c7401"
    sha256 cellar: :any,                 ventura:       "991b8f72530e67953e49ff76e2c08be7642cc739f7dcae6bb2bc4e0e1aa1eaca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ae479f52547a5df3fbee0181a04d38dc4897d3c932dc26af39cebd9c3371c3f"
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