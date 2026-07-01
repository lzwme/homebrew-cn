class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.06.29.00.tar.gz"
  sha256 "3b725bb6a3c8325a31119113bfd8a94a8e1335f3efac71e5af179d31e807d8ff"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "6da02ec7cff11d27b2a6ddc367f4f34b67c0d32e70d0a5aa3bc572d667d22248"
    sha256               arm64_sequoia: "6348d115894235de3745a946c0966bb9aade550ea0cd70c98eae8a52e4b819fb"
    sha256               arm64_sonoma:  "a46e8229bd182b5566c233582e6867016b48be68a5dcc99fbb40fdb82dc76557"
    sha256 cellar: :any, sonoma:        "3115ad337b92270570369777c4e7b106ad138865c6864ffaaa948a4b2561efbd"
    sha256 cellar: :any, arm64_linux:   "9f5f370c92aa778aacfe4512fa614a59ac306b2fa984e5c27a94d8e9d239bf28"
    sha256 cellar: :any, x86_64_linux:  "4007c5904cfe268fb2fd0ffbfbe9bef9706885ef066005be472188d3b816a464"
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

  # GCC 13 libstdc++ no longer pulls in <string> via <string_view>.
  # PR ref: https://github.com/facebookexperimental/edencommon/pull/32
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/7dc082da238446cde535b03370be0b709701b7ac.patch?full_index=1"
    sha256 "1becb3b9bcba13f19cb697baa015bece72b0330e4beae6db5a459f4e6fbff5a5"
  end

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
                    "-L#{lib}", "-L#{formula_opt_lib("folly")}",
                    "-L#{formula_opt_lib("boost")}", "-L#{formula_opt_lib("glog")}", "-L#{formula_opt_lib("fmt")}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end