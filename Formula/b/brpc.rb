class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  license "Apache-2.0"
  head "https:github.comapachebrpc.git", branch: "master"

  stable do
    url "https:dlcdn.apache.orgbrpc1.11.0apache-brpc-1.11.0-src.tar.gz"
    sha256 "7076b564bf3d4e1f9ed248ba7051ae42e9c63340febccea5005efc89d068f339"

    # Backport support for newer protobuf
    patch do
      url "https:github.comapachebrpccommit282776acaf2c894791d2b5d4c294a28cfa2d4138.patch?full_index=1"
      sha256 "ce55b0d5df5b8aaf1c54cd7d80f32c01e8fd35c97f12b864ea6618b38d2db547"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2af87a85e6d75f15512f01442cc4a738a8c0becb5cdd13f46b92cdfb8f19b517"
    sha256 cellar: :any,                 arm64_sonoma:  "95a43bd8abe377cecc3932e7654dc3ec56b4dfe08e09558e51e453cafdae1ce1"
    sha256 cellar: :any,                 arm64_ventura: "3e6f4e3f9d7fc7fa029f68a7aabedf713d2c446a1967865f48e71f90cdcd93f5"
    sha256 cellar: :any,                 sonoma:        "5a481367fa8a12938533fa4e4ef91c8ab019835ae6780e0c9ddc7a340b1a0373"
    sha256 cellar: :any,                 ventura:       "037a83e91466e226a862829f57d9c5b8e67bebcf409364053cce17dcc62b6053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0410f858e2a042f3e4f045bbaea52b4ed43d7cb38c3fd5e7bc0a2a5bbc2b9f"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

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
    protobuf = Formula["protobuf"]
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
    system ENV.cxx, "-std=c++17", testpath"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output(".test")
  end
end