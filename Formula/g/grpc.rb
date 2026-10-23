class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  license "Apache-2.0"
  compatibility_version 6
  head "https://github.com/grpc/grpc.git", branch: "master"

  stable do
    url "https://github.com/grpc/grpc.git",
        tag:      "v1.84.1",
        revision: "b0c0c4f8823ba69e7e43aaaf183c30a43e549924"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/grpc/grpc/commit/fb056ab0bb3ed003febe82f069ff41514288a4f3.patch?full_index=1"
      sha256 "87b230d855ec21fe0a58d6a1d1c726c1a78ccd2cbda6269998f5177f12f10bb4"
      type :backport
      resolves "https://github.com/grpc/grpc/pull/41932"
    end
  end

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
    sha256 cellar: :any, arm64_golden_gate: "c5bfb97fc3acfae28f6440c17ccda52f61ecf1ec0baa926117c84a445b09daee"
    sha256 cellar: :any, arm64_tahoe:       "d371e2af0f0b50d1e9cf8084588bb1d51992e0c175fea8326bfb4705d1714e57"
    sha256 cellar: :any, arm64_sequoia:     "db1c710f5311c5d4aac35b0960eb83e87fee9f32d278232a5250e74bc291727e"
    sha256               arm64_linux:       "eaf0369a0aa092eeef4ef1f73df6f0dfee0a7f99f93f980d8a575ef11dc180de"
    sha256               x86_64_linux:      "59cf58764671937ead9ac309bf6f0d6fbc78c58e98bdbde15926159ef98db5d8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@4"
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

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@4")/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("zlib-ng-compat")/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{formula_opt_lib("abseil")}", *flags, "-o", "test"
    system "./test"
  end
end