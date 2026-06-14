class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.81.1",
      revision: "e84a8a2f04095f2772ba42a4abccde4f9243e75b"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/grpc/grpc.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "15e7f38104f24d81dc4e0a198b7c51cb77951bb504b2566f52407f0859def4ec"
    sha256 cellar: :any, arm64_sequoia: "1e02271f8e8d2c94439f74d5a3e4b011d575129c2d14d1718a33e9824c8bc0cb"
    sha256 cellar: :any, arm64_sonoma:  "e6b60db4f22af103fb7fd7ca556ab65bed70087ce065423ba791515bb30e305c"
    sha256 cellar: :any, sonoma:        "d7beb5b594e429c1fd0e1396c0138fa16c7079adc708e4003f4089982eca9ae4"
    sha256               arm64_linux:   "81d02bea3d6a6297b267bb735de1b7bb2bb64b442fc1caae8e73c387caf5dd22"
    sha256               x86_64_linux:  "4656aea2d4fb5ec0c0c4db326327e4aec8aba420a447675374ebc451f10f519c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_INSTALL=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    system "cmake", "-S", ".", "-B", "_build", "-DgRPC_BUILD_TESTS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    CPP

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["zlib-ng-compat"].opt_lib/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *flags, "-o", "test"
    system "./test"
  end
end