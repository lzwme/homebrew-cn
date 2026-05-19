class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.05.18.00.tar.gz"
  sha256 "9c2c5fba3688fcdb6165872fbe27bc9dc13b26377b4ba9bf66d749547eb6bfb4"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "614e9bcbd3ad652fc440fe13c0e89716e023d4a4d6efabb95c96b5c417dfb9a5"
    sha256                               arm64_sequoia: "a3b755016c1fcb42f6804a088b6cb1c102a4136e66d2cb3fef96fcdb896fa69b"
    sha256                               arm64_sonoma:  "5ed79d367812124b3aeeb29866e223813d97dd9272326b6e66edc33c03861ced"
    sha256 cellar: :any,                 sonoma:        "e62309e355f7875c2598a37c8163989b9e01fdacaef1f81ddff39fd62a4bdd42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67b6ea1a0af3326b26b2a1abc6f9c4ddf68be277bbc9bc22a48b87c1fea9db94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab24989e454e2a463c01402fa069da063af470df99bc2700c5acfed35f6e0692"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    # Related: https://gitlab.kitware.com/cmake/cmake/-/issues/26773
    test_cmakelists = %w[
      eden/common/os/test/CMakeLists.txt
      eden/common/utils/test/CMakeLists.txt
    ]
    inreplace test_cmakelists, /(gtest_discover_tests\(.*)\)/, "\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = %W[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

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

    system ENV.cxx, "-std=c++20", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end