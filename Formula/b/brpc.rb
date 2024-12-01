class Brpc < Formula
  desc "Better RPC framework"
  homepage "https:brpc.apache.org"
  license "Apache-2.0"
  revision 1
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
    sha256 cellar: :any,                 arm64_sequoia: "0614bc7c01990f3c017e153e400abaa9f532180f7634556280cf3d2f5d361759"
    sha256 cellar: :any,                 arm64_sonoma:  "39d8ba07f4e97723f43cbdc7845f9652d93b6cd111d00658cfa22ce368299afc"
    sha256 cellar: :any,                 arm64_ventura: "1c3f90e730c2e661f0509ae8eb9904f4aaeef961bb4e2addc6a3841047e934ba"
    sha256 cellar: :any,                 sonoma:        "01eb2c6c851af152869e83ff7998287462e0904faf32d1b5684a7632416d7689"
    sha256 cellar: :any,                 ventura:       "ae6a60d455ebde6df38d56dc7099df9d8aa91e11756c4ed1151940d2a00092d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2364cda05e6e1a642e4c6e00d66abb85a112b6cf45b28602aa4f7e43a26cb67f"
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