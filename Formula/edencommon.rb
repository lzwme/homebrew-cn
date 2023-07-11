class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "73eb95578acf4ed5771ce49ce60fc2a8c8cdb59cf0d54501871ece47cc7e0eed"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed65238740ef0021285fc23fd609de53fdf76c192bc34ff1582aa5b43f502642"
    sha256 cellar: :any,                 arm64_monterey: "9915550a05b389c5553ba53ee60847bc945cf3eb124ba842b9da4c0ca1492eaf"
    sha256 cellar: :any,                 arm64_big_sur:  "6a4eb19b2c67b165f3d32dd8bc858857b01b0694edeaeb8c70d3d3fa4ff09b73"
    sha256 cellar: :any,                 ventura:        "3a519d9af7694c589e8420df2aab8202f936e9581235a9a4edb4e381acab973c"
    sha256 cellar: :any,                 monterey:       "d53a943d89a61797224a94968661bbe8080c6654e3b3de856ff1df08df1db763"
    sha256 cellar: :any,                 big_sur:        "63199d5b6a0d0fbbbd91bc81c487b3f11bb29cd54567a9821906d3f81f5d569c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48cd448a9860f08ce51951b2bbb951767491757cbb6f04078a652ef0a9cfa7ff"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

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