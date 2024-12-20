class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  license "Apache-2.0"
  revision 3
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
    sha256 cellar: :any,                 arm64_sequoia: "936ae5d786f34fa6a42ec96490e3b755a11a9d8629115068e8351fb4d67d52e3"
    sha256 cellar: :any,                 arm64_sonoma:  "3da1715944951eb5d0804c46b8af9b91e542e344dd2b61c7bc577d25da52679c"
    sha256 cellar: :any,                 arm64_ventura: "ec604fabcd98acf3278497d1a6123c1d02d426c55d38d249584aa08daec1ac11"
    sha256 cellar: :any,                 sonoma:        "d5b5088575f73b50330fc29390de7cf5a9ec1465d50a732255b7db9e89ad86dd"
    sha256 cellar: :any,                 ventura:       "6139f7f3cae9e2b5e52327f2645a49fd0aadf7e28a17fead4284397e3d202dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9858a95aa4eb0ddc2fcee3efbad34632079bd1d4ae273510130d581eeed4a1fc"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

  on_linux do
    depends_on "pkgconf" => :test
  end

  # Apply open PR commit to fix compile with Protobuf 29+.
  # PR ref: https:github.comapachebrpcpull2830
  patch do
    url "https:github.comapachebrpccommit8d1ee6d06ffdf84a33bd083463663ece5fb9e7a9.patch?full_index=1"
    sha256 "9602c9200bd53b58e359cdf408775c21584ce613404097f6f3832f4df3bcba9c"
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
    # Work around for undefined reference to symbol
    # '_ZN4absl12lts_2024072212log_internal21CheckOpMessageBuilder7ForVar2Ev'
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output(".test")
  end
end