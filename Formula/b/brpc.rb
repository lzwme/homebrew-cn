class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/brpc.git", branch: "master"

  stable do
    url "https://dlcdn.apache.org/brpc/1.15.0/apache-brpc-1.15.0-src.tar.gz"
    sha256 "0bc8c2aee810c96e6c77886f828fbfdf32ae353ce997eb46f2772c0088010c35"

    # Backport support for Protobuf 30+
    patch do
      url "https://github.com/apache/brpc/commit/8d87814330d9ebbfe5b95774fdb71056fcb3170c.patch?full_index=1"
      sha256 "33a133c583d39a1d8394174c8c5f02b791411036faa3b1afe38841c3e6b2e0f1"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f31b7d81e36369e0d2ec55b9132ada87532bf8aa057893f572593d275be58c77"
    sha256 cellar: :any, arm64_sequoia: "f2598da1946407248019e3a0bc740a8ec419edfe5a8c976c91b35ec4508c69e3"
    sha256 cellar: :any, arm64_sonoma:  "86657d80f622a5a81b5dd997e157368cc55a94ff59afc634b339092aedf0d8a1"
    sha256 cellar: :any, sonoma:        "09452caeb1c1222d2fc773775e5008bdc108b84a03a5c2a2a656ba4d9dc6eeb8"
    sha256               arm64_linux:   "0288d5505fada48f487874df4145d0db96165e22674b3f1b3aacd86ccacb720a"
    sha256               x86_64_linux:  "3cb1ca3f7d5912784b5f73a0822e6d4110f2606ffd0c029749cbf7592135eef3"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

  on_linux do
    depends_on "pkgconf" => :test
  end

  def install
    inreplace "CMakeLists.txt", "/usr/local/opt/openssl",
                                Formula["openssl@3"].opt_prefix

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end