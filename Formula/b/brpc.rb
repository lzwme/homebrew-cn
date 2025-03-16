class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  url "https:dlcdn.apache.orgbrpc1.12.1apache-brpc-1.12.1-src.tar.gz"
  sha256 "6b315b33ae264e17e4f84bebbd4c3b7c313f5a64de7b398764c68a1dbb4a9e8e"
  license "Apache-2.0"
  revision 1
  head "https:github.comapachebrpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01b7b624e32ab5abbe8dd7aca55c22a5033732b5379eac5c04087b600de372f5"
    sha256 cellar: :any,                 arm64_sonoma:  "a8410a6437e519c6ff5f25522375603a18569d3438909478dc8a3c525c5935ba"
    sha256 cellar: :any,                 arm64_ventura: "f9b1b76688f679da1eed4b5fe3ac4e5e86a62f8427391153d0914c4b495b1c1d"
    sha256 cellar: :any,                 sonoma:        "e8f6647979e2f24fbb48f544e0860689a9c0fc0820f5babcf089db7e8685e3bb"
    sha256 cellar: :any,                 ventura:       "2b8430f800339fdb0fad0f3da628241332a7d8046edc4e9062f4a32f7d6a5a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c9317000db1d52c4c36a0e1bc91bac602bca630af7988f3a0931127ed667d8"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@29"

  on_linux do
    depends_on "pkgconf" => :test
  end

  # `GFLAGS_NS` build patch, upstream pr ref, https:github.comapachebrpcpull2878
  patch do
    url "https:github.comapachebrpccommitcf6b81f9f7ab31626e942c2ef1b56432a242d1a1.patch?full_index=1"
    sha256 "12c062d417e32a1810a8b223d5582748c2f3c4521864a2dd74575b4a10c4484d"
  end

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
    (testpath"test.cpp").write <<~CPP
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
    CPP

    protobuf = Formula["protobuf@29"]
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
    # Work around for undefined reference to symbol
    # '_ZN4absl12lts_2024072212log_internal21CheckOpMessageBuilder7ForVar2Ev'
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output(".test")
  end
end