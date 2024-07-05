class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.07.01.00.tar.gz"
  sha256 "72479eae0ef31c3a9f53453cc01f1b6784f1a590ba0b2b3a2eb9f02ba5db60b5"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b8f50b5e5dd29376dabc448c4ae915c9b114eb0b2e77089a7b71ff9c5a89c764"
    sha256 cellar: :any,                 arm64_ventura:  "5840f79029cbeaf903b3a4e1d084a40b68991fd4081c8c4773420f415ce53f5e"
    sha256 cellar: :any,                 arm64_monterey: "fec041166c202c53b2afec6ea88502deab57b81b2ecd8af310121f40112a4d82"
    sha256 cellar: :any,                 sonoma:         "c221e73242608387a9a16ac3b150367a504a80da806040d8486608183d743ce6"
    sha256 cellar: :any,                 ventura:        "433a2d112cd9b82369318f31df279af85cf7b477a7e162dfff1f4cab790713d5"
    sha256 cellar: :any,                 monterey:       "e3855d15ad957b0ab7130bc34b1d94bcc51e2685189af4491a34f6c1d4e2bcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf255aaf62cb38ff633b4f0e10edd646a84d4da75108ac8f4f3a2af212c762f"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Build shared libraries
  # https:github.comfacebookexperimentaledencommonpull20
  patch do
    url "https:github.comfacebookexperimentaledencommoncommit01bca703032ff108665a83274fb56617b46882aa.patch?full_index=1"
    sha256 "50f704ad44aa6fa8df35d913966c5c28f8fddb8871b35b3420875c804efc386a"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("edencommon{os,utils}testCMakeLists.txt"),
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "edencommonutilstestCMakeLists.txt",
              gtest_discover_tests\((.*)\),
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
    (testpath"test.cc").write <<~EOS
      #include <edencommonutilsProcessInfo.h>
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
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end