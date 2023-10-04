class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.10.02.00.tar.gz"
  sha256 "16ba3c513526a96007171fba40970589f0aac667a2f092f8ee6d26534e2847ae"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b6d1c5414b94e8a810350c0bc65466d09ac6d8ee5324a7d69eea6174eaa71d8"
    sha256 cellar: :any,                 arm64_ventura:  "857cff5db30056b497cd9ceaacfae17c1c5cff4903fbd06018f7cbdab999ceed"
    sha256 cellar: :any,                 arm64_monterey: "2f70e68f61033efa6e75b96efb6d0064cfe24944b7e76e4809e7bca01140c813"
    sha256 cellar: :any,                 sonoma:         "46818831e186d73f4fe67958a63b3399ef057822c515137868d8324a04a45094"
    sha256 cellar: :any,                 ventura:        "2d20647d764d00579e28343bddee72ef6c34812b3d850b0cf353fbe7e7c65b0b"
    sha256 cellar: :any,                 monterey:       "1b5359f095d947398b7b391bea253961ebfb2223dd5cf40bd4a2d53a14c2cfc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d8f9de209f0cd1ce3920dded52f8a9cba5d538406e51dd62e06be103a327eb7"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Fix linkage against folly
  # https://github.com/facebookexperimental/edencommon/pull/10
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/b162c1b8d94b4ed49835da6d03b4d0a550082b47.patch?full_index=1"
    sha256 "99c299fa6df887d1e72aed3d60a8ca32eb2eda1897715482af8ddfa4702fe24c"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
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
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end