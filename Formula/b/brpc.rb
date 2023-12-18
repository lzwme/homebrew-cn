class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  url "https:dlcdn.apache.orgbrpc1.7.0apache-brpc-1.7.0-src.tar.gz"
  sha256 "767fa5d70118ce7dda89edb958da5c873bac7d2e21753892765e0e4ffe4a9854"
  license "Apache-2.0"
  head "https:github.comapachebrpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d6362b167c9b39b6496ac03c7dd3f44225b4af6e01baa7711287e7c96e24426"
    sha256 cellar: :any,                 arm64_monterey: "4329a5f727e5191c2ba4f0867eb508723754619bb57e08c8185ca9460e2290e3"
    sha256 cellar: :any,                 ventura:        "18950c2221f71ebaae25aed94896ff813a5067376a73ee1801d8cf99b85c8a2e"
    sha256 cellar: :any,                 monterey:       "5ae5b53f0178a13bfb99d5160ee71e1bd5186c0e223a8098c679ff23008f4bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1401707da2744aabfe5ff96085ae0791505b7bc8894280898b62dece143fb7d"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@21"

  def install
    inreplace "CMakeLists.txt", "usrlocaloptopenssl",
                                Formula["openssl@3"].opt_prefix

    # `leveldb` links with `tcmalloc`, so should `brpc` and its dependents.
    # Fixes: srctcmalloc.cc:300] Attempt to free invalid pointer 0x143e0d610
    inreplace "CMakeLists.txt", "-DNO_TCMALLOC", ""
    tcmalloc_ldflags = "-L#{Formula["gperftools"].opt_lib} -ltcmalloc"
    ENV.append "LDFLAGS", tcmalloc_ldflags
    inreplace "cmakebrpc.pc.in", ^Libs:(.*)$, "Libs:\\1 #{tcmalloc_ldflags}"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>

      #include <brpcchannel.h>
      #include <brpccontroller.h>
      #include <butillogging.h>

      int main() {
        brpc::Channel channel;
        brpc::ChannelOptions options;
        options.protocol = "http";
        options.timeout_ms = 1000;
        if (channel.Init("https:brew.sh", &options) != 0) {
          LOG(ERROR) << "Failed to initialize channel";
          return 1;
        }
        brpc::Controller cntl;
        cntl.http_request().uri() = "https:brew.sh";
        channel.CallMethod(nullptr, &cntl, nullptr, nullptr, nullptr);
        if (cntl.Failed()) {
          LOG(ERROR) << cntl.ErrorText();
          return 1;
        }
        std::cout << cntl.http_response().status_code();
        return 0;
      }
    EOS
    protobuf = Formula["protobuf@21"]
    gperftools = Formula["gperftools"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -L#{gperftools.opt_lib}
      -lbrpc
      -lprotobuf
      -ltcmalloc
    ]
    system ENV.cxx, "-std=c++11", testpath"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output(".test")
  end
end