class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.09.25.00.tar.gz"
  sha256 "b99d5ff5b80208c507c5bba04401c3d1cf4bf0f1699976596758a150daaae3dc"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75ccaba16e1d5b1919ca73bd127255258ac23b63a739af9f3a84d7af5d866149"
    sha256 cellar: :any,                 arm64_ventura:  "59dc5b9b1b7edaf6f9639de6fdb23de83db82bd6b4a67121a91c978d240c782e"
    sha256 cellar: :any,                 arm64_monterey: "eac0cb37239cdab19f539ffdf20f59db914079f8deee0eddc68d96042b0afd49"
    sha256 cellar: :any,                 sonoma:         "d179e1a7a2019712b2123d4a17b7c4ff12fdf36c1b33f8351479223f33b58b63"
    sha256 cellar: :any,                 ventura:        "64a81185f13bf7adb28ba2c78800ba7efb917cb36dda510a31590a821fc21173"
    sha256 cellar: :any,                 monterey:       "719108edb52ed44e034974e51249cc7a58fe5e884acfe37b5c0a72b3ae37746c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bab49f0f4d9b14ddb560ce8a7556cd91e92e7126b05bc4f2091d8fd6b99e4de"
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
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
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
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end