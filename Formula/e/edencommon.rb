class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.08.12.00.tar.gz"
  sha256 "8fc9690845d02ec9c25effd574b732afa7839c15488884fc6fbf9fdd28569c94"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e7b06db3bc3c180d6ffa182aff993bb4bb3d50bf88f8b799e8e4407ef555a99"
    sha256 cellar: :any,                 arm64_ventura:  "2d1db38fc6203c84ddd7fc2d248f4b242a56cc11e26d84ea1334e0f30c5807f7"
    sha256 cellar: :any,                 arm64_monterey: "01811e67a6dbbedaf0307f4027faad8ee748d38e3ffec2ce955a983040bb7bfd"
    sha256 cellar: :any,                 sonoma:         "8e2c8243affb9d6a73841663ed7bc1997b63ce1b6d1e3807cbedef2308853180"
    sha256 cellar: :any,                 ventura:        "232ca8327a5e110e3e02bda8c1d24b38b143b5b621948bf566cd666b8658f025"
    sha256 cellar: :any,                 monterey:       "266752433da3bb8db6c2f3702cea14f7d46ae8501fe97c2c1fb5e238d7fe0431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc348491ca93208061429950b491062c3bfadb82cbff886698f4312b2ab9f88"
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