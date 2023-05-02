class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.05.01.00.tar.gz"
  sha256 "e7d333e92154b370c67bdec308abb9caf00288b38402bf5cdc76ef4e0561dbf4"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce8c9eb4db1f8ca56cdca5feb1dfd96584a70a87a44f97fecc36ac6d391d0f03"
    sha256 cellar: :any,                 arm64_monterey: "74ead204b60d6931a06a17f7041ce1594c734bdf332fd04fd162b4a99dda9098"
    sha256 cellar: :any,                 arm64_big_sur:  "9fb61a5a016cfe6d9bbe2f981a73df943bcc6c813afa2042c2821c90fb8aee73"
    sha256 cellar: :any,                 ventura:        "5b48a1a71bbe6b851495cc0f25a7930b6f2b902bc5fd0bbf1879eb01f18c95be"
    sha256 cellar: :any,                 monterey:       "e6425c5fee9b41b780de55216c60c9599c4e4b01bda15a6d63d06784bdfbce03"
    sha256 cellar: :any,                 big_sur:        "4a5ff074646df5bf7e1f87bc7bb5e13094df1e2ef1bb0cad3d84b350e4c7ea86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e735ad350cdb8906acb6c27b7f93ba4a8390b7c9ff18152581bbe1152096558a"
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