class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  sha256 "4d5e84048e12512c008d24e52c9e0baa876b5f3f9b06f0aead38b55ea248fdc3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "938c07ac932b5f32be2d95cb031ccdc6fb46c4e9be8314e3da673963866a7416"
    sha256 cellar: :any, arm64_sequoia: "558bdcea59410890c8e5b57c9220d7a97b16facaa3c903f9bdeaa93bfa5cb060"
    sha256 cellar: :any, arm64_sonoma:  "02d37b4c99058ed78f471c4ca6d0ffa5e345a0d4430ecb86455c1a8d34e21c72"
    sha256 cellar: :any, sonoma:        "8d694fdf5ff72dd9f4e964f697331fd1f6c5b55cc36dfc62952d7be6ace4e4b2"
    sha256               arm64_linux:   "a0a5fe537237d544e5304b878f9c8c834d24a41c89d7d9f3ba7174f073401957"
    sha256               x86_64_linux:  "ac476089bf5b946e877158494c93c45cc3c73b68d3c3bdcac9cc7faebfd9643b"
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

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end