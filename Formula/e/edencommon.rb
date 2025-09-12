class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.09.08.00.tar.gz"
  sha256 "8bd6a7e9cfc0043c9ca3ec4039414616474b522cff97c0c3d516da0708944c7e"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "0df77b368afad1c7e5188426699aee6a1a55c698cb657f8ec9f173144738f747"
    sha256                               arm64_sequoia: "43c83f51ce944662a07fd175f613b0634765bbb60414ac9585bb24907031fa09"
    sha256                               arm64_sonoma:  "e10cebcf939e2d09ea92c678dbcc3907815ea185ba215881b5ad6a25a88a3956"
    sha256                               arm64_ventura: "ecaeb6cb044b24c90f9eec18708a3f7eebd027ea19b43f2de8894257eb9cefe4"
    sha256 cellar: :any,                 sonoma:        "a0d7e72acaee4af440701619c4196476c65d95f71a4fa8518973841476a45bcd"
    sha256 cellar: :any,                 ventura:       "6e1438a4d259f00dd28d0dc331c660bc4f2408d0eadd7b4cea18bf941b1c7827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84254cb2a0d56964ac8c3231523bfa41ab77cf95e59ef14aed0d38591249fea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7b69843b9088165a70d5ee9b2bdbfc566d918307233ddf6fb828662c778347b"
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