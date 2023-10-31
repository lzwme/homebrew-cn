class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "aac921b0df5e6300e294657245a3b1d49663f58e7907f0aae68f60288a3b8c11"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81d149bfc325917ed6c5abd83983710dd36bec39bae2c1d5cbbfa2b3cbd17555"
    sha256 cellar: :any,                 arm64_ventura:  "900bcbc2c4af768962334900a619fccada5db42aef350b15286d232d0f6aa52c"
    sha256 cellar: :any,                 arm64_monterey: "c12858fc4437dadc2e7596fb488c69d6a02f8714224effb731550accba8d964c"
    sha256 cellar: :any,                 sonoma:         "006a979f0e5eaf174169c77236b6bbe1afb9c92a6a04c40f0cd3ce0234b2c70b"
    sha256 cellar: :any,                 ventura:        "3dbb41dacb95871a9a21f5563f0c0c42282d924f93ce0b2703cbf48e2ba5e61b"
    sha256 cellar: :any,                 monterey:       "b529cfa7da721cac0116bb804832de0f3577bf07418bdc8a1bec217e64ee7079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "243b4c649d906f89c6551f1af08c140164510a46d45bc94f4df645ace6e94971"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
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