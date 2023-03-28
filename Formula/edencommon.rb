class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.03.27.00.tar.gz"
  sha256 "6ab7e9153d8ed20d5e4a5f47ef13c510dafd93fc694a44ff333794a86b151a4d"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bf405d6180564d03ff8a90e675363e2b17d684e8a56120492b47764e00bd3c57"
    sha256 cellar: :any,                 arm64_monterey: "b891c30db2d7ab3e63e3e1d8499ab695b6a3b5f6658ade734b85f4347482e297"
    sha256 cellar: :any,                 arm64_big_sur:  "fd45233ee76f280cd6aefe6f0a9ba5d5b7facac723c906e9410529ae4bdd0bf1"
    sha256 cellar: :any,                 ventura:        "ad6cb26f0ac8f7db2eedea071e8c60a1f23230e7f5117a9a5de8142688cf2b2c"
    sha256 cellar: :any,                 monterey:       "270b85436e46b797519aa2602c5368466e18d9c7780b0f336cc1091cb4312e81"
    sha256 cellar: :any,                 big_sur:        "c4d55bd10bd2c0496339253090116173ca0a86fe1472abe64ed0892a324f7ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e8a92e4ca7fc84154b53bc41b571a7cd56958d79f2ae14bbaa8b3928bc2586"
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