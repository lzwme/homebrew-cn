class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.17.0/apache-brpc-1.17.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.17.0/apache-brpc-1.17.0-src.tar.gz"
  sha256 "30fc544c74ef51419d262d279571c2c1b5db7dda1bc3bad893b1397d676fd02a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7fd8baf767991673bba617384ec439e08470bb42a5b679b0f99cf9eaa8d26025"
    sha256 cellar: :any, arm64_sequoia: "6d2313037b1c3aeaa5ba115adc652853d0f3c902f1b6b88232d0c93a128094ce"
    sha256 cellar: :any, arm64_sonoma:  "e61659c49d7af11b031c9c3981077eaf9b5d193f60689c92507c2aa0bd89bc32"
    sha256 cellar: :any, sonoma:        "80e31ae699d6e09b700b7cc5bb780319f1b7ff229525d8be2bc2b9adcc352328"
    sha256               arm64_linux:   "77f534789724d3585deae2366b4ff5a9048e003382b83fea2be96eb839239230"
    sha256               x86_64_linux:  "1dfa5ea83cc675b6eb3089fc4335ba3c9b50fb472acff5bfc3cffb1715dcb6ba"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@33"

  on_linux do
    depends_on "pkgconf" => :test
  end

  # Guard the Linux-only SO_BINDTODEVICE socket option, which is missing from the macOS 14 SDK
  patch do
    url "https://github.com/apache/brpc/commit/d7fb5e33bc3b39a349eef619d7d6cacd623abf4c.patch?full_index=1"
    sha256 "0d7d064dd77360995c643cc7e10b9bc42b04f5cccf33992160288e654e588098"
    type :backport
    resolves "https://github.com/apache/brpc/pull/3320"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>

      #include <brpc/channel.h>
      #include <brpc/controller.h>
      #include <butil/logging.h>

      int main() {
        brpc::Channel channel;
        brpc::ChannelOptions options;
        options.protocol = "http";
        options.timeout_ms = 1000;
        if (channel.Init("https://brew.sh/", &options) != 0) {
          LOG(ERROR) << "Failed to initialize channel";
          return 1;
        }
        brpc::Controller cntl;
        cntl.http_request().uri() = "https://brew.sh/";
        channel.CallMethod(nullptr, &cntl, nullptr, nullptr, nullptr);
        if (cntl.Failed()) {
          LOG(ERROR) << cntl.ErrorText();
          return 1;
        }
        std::cout << cntl.http_response().status_code();
        return 0;
      }
    CPP

    protobuf = Formula["protobuf@33"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -lbrpc
      -lprotobuf
    ]
    # Work around for undefined reference to symbol
    # '_ZN4absl12lts_2024072212log_internal21CheckOpMessageBuilder7ForVar2Ev'
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split if OS.linux?

    system ENV.cxx, "-std=gnu++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end