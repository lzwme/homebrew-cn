class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "f1ad243fc528a50f1c2715d3077f78a8b582075994b2f0eb2c32ec163b4c47be"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70fcd983e8d3b47d9d3e5e66c3c4a2aa7f270b231c43d788a284b6fc5edd238b"
    sha256 cellar: :any,                 arm64_monterey: "c4f629af2a6a7d3147d9417d529b6f313f3c2b4349ee97f84a52804d5dbce7c1"
    sha256 cellar: :any,                 arm64_big_sur:  "24bf6944b7474534b11c4a02c516af89ea97bcc8637ef93e0a1326c5efc45255"
    sha256 cellar: :any,                 ventura:        "7ed5560050d80ba86ee8d68b54fe7fc54fc6ee8faf6afc98f40dee6408a36fd2"
    sha256 cellar: :any,                 monterey:       "ab529659abf8e409e8ff35cb2adbbf534226b1402964fbc6ebdee2524841857f"
    sha256 cellar: :any,                 big_sur:        "b751da6aa7af90c12ae62521675298864c1e45466061ab31214c1676451afb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2476e4f93065f3fa034fea70f0e227b9a034672d7fff5b642253777d2c7be49c"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessNameCache.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      ProcessNameCache& getProcessNameCache() {
        static auto* pnc = new ProcessNameCache;
        return *pnc;
      }

      ProcessNameHandle lookupProcessName(pid_t pid) {
        return getProcessNameCache().lookup(pid);
      }

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << lookupProcessName(pid).get() << std::endl;
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