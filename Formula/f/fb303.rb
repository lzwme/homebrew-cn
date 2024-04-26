class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.04.22.00.tar.gz"
  sha256 "ccf829c44ad7c34ff6dbd71b2bfbc56c38e899f4ebfc4ef192a7868f6c2ebf28"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "506ed462ef42df14870a065d91f53fa54dbd7a5ed297c85c3915d64fc1bf531d"
    sha256 cellar: :any,                 arm64_ventura:  "a7efe2bd93dc75e62a047a00e0c09bcee760f63aa29c75a1a7a2e5f1fc2eb7a3"
    sha256 cellar: :any,                 arm64_monterey: "cc0ff25b110670a6fc0ee37b7cd7b4fcbbe4dd9fcb1fa6248944200a84677837"
    sha256 cellar: :any,                 sonoma:         "57c466913569273ce6f11b0f30cf09f58fba0fcf1678eada3d64df5b601c8a16"
    sha256 cellar: :any,                 ventura:        "fc216f7462b78bad1ec33296f40d7579eab6ef5bb0c8b9cee0a08621533ebfb1"
    sha256 cellar: :any,                 monterey:       "f92770d4f25d703a1ddcafe0238c7664e50f53fc19136a64faed74373cc4a3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c31c0a6045b998a9c3496854b9da1259870c58b0f9d57bbfbf78606e3878a6"
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