class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.08.05.00.tar.gz"
  sha256 "c3c96436de823abb37ec4ffaf9041c0fb322a9f1a82e236788d0ca2b6f1e3f9f"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "863549ef846f0dbefd420e8908f585b5b13ceb93c38de22212c9653890b7697c"
    sha256 cellar: :any,                 arm64_ventura:  "d46f0b7b95e251ff3be6e81bc7882b3c8522a40bd1a4f18c5c2cd21569df30c2"
    sha256 cellar: :any,                 arm64_monterey: "f22aaefa851b701b630de15e7b81b4513f03cf90a3823f7c73d4a86621bc88cd"
    sha256 cellar: :any,                 sonoma:         "321ae2c4850ead029f18de38b25bdffae8f8dea9bf84e0f0fbf20e4d92d0fe25"
    sha256 cellar: :any,                 ventura:        "119ab91c173cf21228543ed2090b040c9d2e143da78825b1a8ec7824680bf2f3"
    sha256 cellar: :any,                 monterey:       "f326342a27a8358b9b7e45795117a6bc1e77df6e0fb0103e9da87a0c013e7bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d348dfc7d49612df78b81609b10eb3879287452dd5efcd49c8479d828fbb76b0"
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