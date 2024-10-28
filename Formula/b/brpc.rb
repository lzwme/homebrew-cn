class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  url "https:dlcdn.apache.orgbrpc1.11.0apache-brpc-1.11.0-src.tar.gz"
  sha256 "7076b564bf3d4e1f9ed248ba7051ae42e9c63340febccea5005efc89d068f339"
  license "Apache-2.0"
  head "https:github.comapachebrpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82032bd16d682bc0a4ac13e4ed8e049b8eb6aba3eaff0bbcd8093f73351055f8"
    sha256 cellar: :any,                 arm64_sonoma:  "84457078b35b3b2a39795603b7ddbb74a0f3e3ab31f6a483f5242db4bae380d9"
    sha256 cellar: :any,                 arm64_ventura: "7fd8f2b4e848758970a85c3b96f1130776866f1fac7a4230336568d3e98f54d1"
    sha256 cellar: :any,                 sonoma:        "24952c34f4b63c8223c4835a71f89f6d71066897744baa975781ad26601d8b73"
    sha256 cellar: :any,                 ventura:       "750b019abdf60ed6bf8cea613bed38ce50af6cdec99913a088fafd9cac9ca7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc416fd5a6eeb21558e746e52543efebf91536633ae38c149b36898d5f98bfc7"
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