class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.09.09.00.tar.gz"
  sha256 "6c028558b6c009dbac00d7a30ab974e8f9b966ee04e00eff88cc076b8a2f9573"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06e0fc5866d908424231e4fc28c43ea446c3c2b6f2ef7d5a9ec16eb08f20779e"
    sha256 cellar: :any,                 arm64_ventura:  "e93cde4d65afc35675fef1fa1da8efdff89131502dc3d33c11f44210663981aa"
    sha256 cellar: :any,                 arm64_monterey: "3a3f6e5291746cd314213278062625974a42111eed22132ca03492ed52d21e85"
    sha256 cellar: :any,                 sonoma:         "ceeb8a9e620423e9bab3c0a17f400d9697591eb476716f9fb9014f0fcf68eb6e"
    sha256 cellar: :any,                 ventura:        "9bae61d394eaef6d5ee563f26c10e76288e32e9373098afb1574fa066252f2fe"
    sha256 cellar: :any,                 monterey:       "dbdf23e6aa3baf6b8947c5a1e7161196b212396547db42aba21ad209adfffcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa5704670be592fea96c0193ed0d76287b17c5028a0af149382c59de07f5022"
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