class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.15.0/apache-brpc-1.15.0-src.tar.gz"
  sha256 "0bc8c2aee810c96e6c77886f828fbfdf32ae353ce997eb46f2772c0088010c35"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a717956c5a369f398e56b76ff82b4d174bee5ac45e146c71622d150752cc8204"
    sha256 cellar: :any, arm64_sequoia: "be8f287e39290e85309bb5edc8692247e6a2a9a12ff60e746d9a4a416af10097"
    sha256 cellar: :any, arm64_sonoma:  "077f72babfe5e3360ac3ea4c1bf7360576fe529fdee919d5bd952ea2b18ba78a"
    sha256 cellar: :any, sonoma:        "36626965d76c93590d8676a1f81c321298c251c9ef0e4b64da63ec8d0cfd0c0c"
    sha256               arm64_linux:   "3ec33864c3e4c1ae23eff2ae7d3cdf560a44b1fafc956ad1f26c0ea7044b9bb9"
    sha256               x86_64_linux:  "4d0b4d90964afcb19e0dea4ac28d731579a246f002160a13fbd14b223731ff15"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@29"

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

    protobuf = Formula["protobuf@29"]
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