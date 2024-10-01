class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.09.30.00.tar.gz"
  sha256 "278a43c0243b0961fd40740e7763ec13a168cce675a0b3eb9327dec4bdf03723"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a20a0d067f9f38d3873f0786746a25b7afb8b0dd8f3321f53ac665810840d295"
    sha256 cellar: :any,                 arm64_sonoma:  "39e8676b7d2d305fb855ecb472a13caa55300040fb3e2af834e39d680f9377a8"
    sha256 cellar: :any,                 arm64_ventura: "afb501ddd75f9405e7b0395b9f21067914f17e2af79ba3e7ebcd32b9cb13b94f"
    sha256 cellar: :any,                 sonoma:        "63eb7400adce84ed5774b12d04322dd351fe9a10ac4a5dc63fd9676cfc630ba1"
    sha256 cellar: :any,                 ventura:       "6d26eee27efaa7853d519cea77b02bf7c87935450bf75e540cbc4ff5eb379906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364e4cf45ce6bc9322e0bd63ea5c882cff3c654db1f4817250d45b074d6bfdb7"
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