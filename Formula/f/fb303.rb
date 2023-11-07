class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.11.06.00.tar.gz"
  sha256 "737895316696ada243e24226b17114fd4cc4f0f790b91d65705f5ad0c309779f"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2be8e744c54f87b3e57cc8cd9f97d2a62ee01257bcb7d8703cb7a3cc8d105a28"
    sha256 cellar: :any,                 arm64_ventura:  "86c1276795a95e3e4dc9dc9a4faac559ca33e034fa30f0f73b277a07a9e99e36"
    sha256 cellar: :any,                 arm64_monterey: "2caeea0acf9cfafaee2ad5e37809081f23cc6ccab1c0687803cf2a2c7375f2b6"
    sha256 cellar: :any,                 sonoma:         "77cd9be096a3ca31b5a1bba1cf3bdc1042e545928cb42e878e5e263e24fd7fc1"
    sha256 cellar: :any,                 ventura:        "2725b19364c7f32bd969dd3954b4145e25f9ec846ca86706d9c6305c18b68b9c"
    sha256 cellar: :any,                 monterey:       "87e5f98978c2f7650d14ae763cb398aeb650f13eda4a1bf7f07bc69bd57cd420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cfa8ff2677d157323678d7468c7b52f9dad62d4ff14c7ff3f19075a662148b4"
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