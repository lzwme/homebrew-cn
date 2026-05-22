class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  sha256 "4d5e84048e12512c008d24e52c9e0baa876b5f3f9b06f0aead38b55ea248fdc3"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1bc8451f5886ddc12870b28f65e4567e0466b31f716f3233d6c8eda1ddc8005"
    sha256 cellar: :any, arm64_sequoia: "f306f972a67b84cbd3c1ee74351524051367679322ad0bd807a19a384e2ea041"
    sha256 cellar: :any, arm64_sonoma:  "292b412d1a4767a13566f95dff6ab2e49e09fd95965a4a39587b252270070f52"
    sha256 cellar: :any, sonoma:        "28063f3693b279bfe391c739c7bdacb72d7cea13950c7a3859792f18a0b0c4d2"
    sha256               arm64_linux:   "de977ffebfe75e6da99dc89fa1c667755c4638f64a1b5963b396ccd85cd7a576"
    sha256               x86_64_linux:  "9b30c2043f5900ffb2f94b774106911f1fa86dc4bb5a6456303d6cd7f6834b79"
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

  # Apply open PR to support Protobuf 34
  # PR ref: https://github.com/apache/brpc/pull/3241
  patch do
    url "https://github.com/apache/brpc/commit/09b50d2c144e20e687c53829c89138caa7f1f31c.patch?full_index=1"
    sha256 "85536080d6ef84b446c7a3277dd0a6b8ac9672366bde8709abb4e592dc5f61b5"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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