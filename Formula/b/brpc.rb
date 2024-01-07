class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  url "https:dlcdn.apache.orgbrpc1.7.0apache-brpc-1.7.0-src.tar.gz"
  sha256 "767fa5d70118ce7dda89edb958da5c873bac7d2e21753892765e0e4ffe4a9854"
  license "Apache-2.0"
  revision 1
  head "https:github.comapachebrpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4bce25aba8fa6a143a9aa46f0bad75eb9a603f08f70f7b434961520c88a6991"
    sha256 cellar: :any,                 arm64_ventura:  "307d0b8c7ad1db29dd8a1a52540c039848f386b8acbbc087140e6e96ff6d49cf"
    sha256 cellar: :any,                 arm64_monterey: "637cbab632fb6d603910b8bb043ebb45cf9926cee44bc1939ec1f31b1ad7ad2d"
    sha256 cellar: :any,                 sonoma:         "26e244e4e57e55f60099945af92a73564dfa88b9b72c0ac567a2e5b7d8f9dc2d"
    sha256 cellar: :any,                 ventura:        "fe48323b0ae2afd87bd232f967e86caf6037d0fee594882f0dfa4f0868ac0176"
    sha256 cellar: :any,                 monterey:       "0daded2c313247e5fcafc36857bc7fc712fe6726373e517e36c7fb6580b4eefa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1333e52457be795ac541ff21e8671a586fbb4664a7ab98fc59934befcfebd19f"
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