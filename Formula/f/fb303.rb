class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.06.17.00.tar.gz"
  sha256 "a8357caf293e2e5e513c20d61aee869d52633a10c73c799da7d34c1e4fcfe372"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d65df5f30994ec81136717023e45f1478b71835281cc501bb38e566bd54efb61"
    sha256 cellar: :any,                 arm64_ventura:  "e8ec9e0efb161c7ceef4f3cf809b8151e9b122f4a0241a6e56e5713e91c3834a"
    sha256 cellar: :any,                 arm64_monterey: "114990ad43424ffce9f285d9ea08898a121a4e57802469e4ba554774087fb253"
    sha256 cellar: :any,                 sonoma:         "5f33bc821ca3349f3b82858a73981e0747a59aed1555460fd5d46d73cd7e167c"
    sha256 cellar: :any,                 ventura:        "be83c4226980e918beb6270c2032da5cd98978566e56945b40ac9bd31704214d"
    sha256 cellar: :any,                 monterey:       "56b7a9016ca16b045e49e135996d5db1d4069038ef6943bdce055adb032a8a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf517394fa8fcae23d072ebbfdcfca6c46cf98b4e552061c7ae22baffeda020a"
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