class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.18.0/apache-brpc-1.18.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.18.0/apache-brpc-1.18.0-src.tar.gz"
  sha256 "26497bb50a8e06c8ffe24f37325431b1ca72fffd447de6fa3eb0002db79c978a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a5ffb1d3daf0d8fb3cb572cc1b0c3104b3a7b5276ac51d6beff35f46d11ada02"
    sha256 cellar: :any, arm64_tahoe:       "11b1209c74cc8a3d4038a32a203db35afd67352455a4f7ae1e6a610292bbc08c"
    sha256 cellar: :any, arm64_sequoia:     "f87c76f320709612a87cf76c1ed5884c650b846a19aaa29b5d2bf224f66b0638"
    sha256               arm64_linux:       "a5e7b2f2c09a03e8281c1f39f4483f676bfa191e03d0b415703eee59f759f1c5"
    sha256               x86_64_linux:      "16cb87cfe35958809d1fbd428b7ec965335130d443d8b6d3f17e2a95c8af80d9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

  allow_network_access! :test

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

    protobuf = Formula["protobuf"]
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
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split

    system ENV.cxx, "-std=gnu++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end