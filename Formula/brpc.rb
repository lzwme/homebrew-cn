class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.6.0/apache-brpc-1.6.0-src.tar.gz"
  sha256 "06ff4adebc720bf1529b03ade872cbd41c6ed69971e6e0d210d57d7b72856bd4"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39fe097809985948cc09a95d7eb1d4129dae953e8bbfe2110505a0646d969a1b"
    sha256 cellar: :any,                 arm64_monterey: "22a3e4d69677e808b8818bbb13b3802837ee5205da638bf5457d3029cd067dae"
    sha256 cellar: :any,                 arm64_big_sur:  "2eed67dd7aae9ed66a49bb0edb543e33e1ce42f6d6834edc0d92079773b6514b"
    sha256 cellar: :any,                 ventura:        "e545840858bf28dbf18ed87ee02d52134de197879dda5f8626b59034378eac8e"
    sha256 cellar: :any,                 monterey:       "ca32482113f63bb3780ed60179a97338773b87a8d7b81313a9d5b89c0b146047"
    sha256 cellar: :any,                 big_sur:        "b0804f2363d8569c3b5592b279cc8bec108e2123718d1167d7fb53c5e15d4394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586e212491d35c2f25f454ca07de3d61642303547d8f466c6f4da76d7a9a3536"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@21"

  def install
    inreplace "CMakeLists.txt", "/usr/local/opt/openssl",
                                Formula["openssl@3"].opt_prefix
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    protobuf = Formula["protobuf@21"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -lbrpc
      -lprotobuf
    ]
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end