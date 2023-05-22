class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "f1ad243fc528a50f1c2715d3077f78a8b582075994b2f0eb2c32ec163b4c47be"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f4a8016a0c3a7112c86baca3f75ab3e0149393644aa020e55e008f6bbc80820"
    sha256 cellar: :any,                 arm64_monterey: "91477dee71b4a3cc7632bcddcc67c1804067cc141e7525e142a8c86f3d0d710c"
    sha256 cellar: :any,                 arm64_big_sur:  "fb5f094cf5a09f55b69d5726d84b0b4eb63044b50f3212fa5f061c47e11eb1a5"
    sha256 cellar: :any,                 ventura:        "1ac96890ee9eabac29f21666d955caa1bdcf428203eac241a123fe40d6adb56a"
    sha256 cellar: :any,                 monterey:       "1140b3d9ca6ba027ab63b50de0d35b33f49892132eb8cfae0de89ab57733395b"
    sha256 cellar: :any,                 big_sur:        "57184d06e44f222dee964efc811bc82a5378d57c3b460733a5a0e2ef772b9f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30d9d0dd20cb7f824a80000898eaf71b3169f94d00316b353e0be8b8b41d1c1a"
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