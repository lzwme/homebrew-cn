class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.07.28.00.tar.gz"
  sha256 "6f9306e50cc1221e5c6aaa3805dd0b8138506db0c3a018fe6a0c9e6610dd929e"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "2ae35f3cde59dac2a464fd9c5f8094ed3524bd5fab3686b32f21b1a8007ee4d4"
    sha256                               arm64_sonoma:  "70d97e4da2c49497ada499330c5b71a52bb5632eae27c7fab0e27aa7a5042feb"
    sha256                               arm64_ventura: "8c2646fed47d098603a33b5bfc369ca7d5b3346faab263a478e6a34c8bfd212b"
    sha256 cellar: :any,                 sonoma:        "a3b6e54ab1727793f22a624cd7ee222d1ee7e1ac7e0d159c730c5de38a3c333a"
    sha256 cellar: :any,                 ventura:       "5400959bb254e3e01d0513bad2ace087172e6af528626c13ae745d742d852ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17da24232524dbf005599f2bb82352978d0ca77015b37164c2791b6d1ec4ce98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e229c6d71c9abe534fcf949f5e98889906667bdc8340282c325651e49873350"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end