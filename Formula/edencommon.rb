class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.08.07.00.tar.gz"
  sha256 "78eac6d9f830802553766b6cc0208670d826f70fbb6a5d99c1ef1a52eaec6bc5"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09c09706064831a171bb2a2e1f78185a4d90ad76d419889388562435cb624293"
    sha256 cellar: :any,                 arm64_monterey: "341c5e22d12098358e478b902d6deb332168c4af8b424024d5a2d624d38ca62a"
    sha256 cellar: :any,                 arm64_big_sur:  "c7e48bcc1b8c8df13085f530efed5d6c29602189a38d584f3c3fc08e50f6fba7"
    sha256 cellar: :any,                 ventura:        "43253ee1e937b7cba893ce5d7a592d9a72d1d8f14a0c0542955b79b32859555b"
    sha256 cellar: :any,                 monterey:       "2723bf2a4e442810fc740c048d2b02af9cc344d5b105d901be8bac1c36f01c0e"
    sha256 cellar: :any,                 big_sur:        "3824060f2fd3634ecbf19a1807fbdc3f4be3f23d917e38dcfc8a1b5078bdc3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5e63502690044a18af5a43a88c91c1dd8877327f5e34ba583cc11dfb0f82508"
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
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

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