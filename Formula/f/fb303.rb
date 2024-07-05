class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.07.01.00.tar.gz"
  sha256 "91dc419bed9fa2cc9093172cd28414f432117a4ef59197328979432894284225"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b2ff31605f878a0044744947b42f80ed4928795e16d6d0152e9b6887f4106d8"
    sha256 cellar: :any,                 arm64_ventura:  "2a0bad1236ae7c512535f72a54bd95cac748bcada2f252df3cb81d4a63d6bdfd"
    sha256 cellar: :any,                 arm64_monterey: "503a0ca9a145a68e17869425780a3cca40908f6c4ae3b54bc5a773a32a38826f"
    sha256 cellar: :any,                 sonoma:         "18784db69b153f6f6f9173ec0715fdc6e5f79a17eabb11c8ec2a7bafc3e1167d"
    sha256 cellar: :any,                 ventura:        "85336a929065947c14c5cef30641adb67265264c54d7be7b58b9e084d7fc909f"
    sha256 cellar: :any,                 monterey:       "515a9be7eb953cb30a604907c41d63ec5fa4a5fe497992fb35385d23119128d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4060c368850d6cdbf4e4c342f477a39f3557dc9f9c146a0691ce63285f56a2b"
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
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end