class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.82.0",
      revision: "742600a76f5717044cde93ba424500c680e2002a"
  license "Apache-2.0"
  compatibility_version 4
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
    sha256 cellar: :any, arm64_tahoe:   "e0e68f656d7da8282e59bd5dc6d104b3193a1d59bab3e6ffb51a2cc53e57953b"
    sha256 cellar: :any, arm64_sequoia: "25b756c5ea5dbe72c76f81c874874b17392fde4754bd522ff128ea9699d6bba2"
    sha256 cellar: :any, arm64_sonoma:  "4b8fc9809ce6d4e3197254499b3fe2c437ab31d7ba9e26d5af255dbae71a19f0"
    sha256 cellar: :any, sonoma:        "2a1c823c935b04859d47f7c4d48901012a754d200ce0523a4114f63e2eaef945"
    sha256               arm64_linux:   "82beaa71615277eccc048dc6be3643cb6783311493289fcec4c1380f1d09f8df"
    sha256               x86_64_linux:  "315b21fdf9478ed3197de6d1d31c6ed27740c7a3156139014f10acb943c3ba24"
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

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@3")/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("zlib-ng-compat")/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{formula_opt_lib("abseil")}", *flags, "-o", "test"
    system "./test"
  end
end