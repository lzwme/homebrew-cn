class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.74.1",
      revision: "893bdadd56dbb75fb156175afdaa2b0d47e1c15b"
  license "Apache-2.0"
  revision 2
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
    sha256 cellar: :any, arm64_sequoia: "8131cbb5dcbef1d24b37c5fc429b3ac26fb05507e4d3ea98bdcf671a7923326d"
    sha256 cellar: :any, arm64_sonoma:  "efba12a71b429f128b41294100a0ee6de7f5ceb66cacf16175bcc793eca1e548"
    sha256 cellar: :any, arm64_ventura: "d03917fa18fd3b64b15adb06bdc32a6005a80bba72ebacbf7ff8a9c30867b01a"
    sha256 cellar: :any, sonoma:        "a39fe2b1692e943243b3421e16dd740dd72834144a1bc64b6b02093f2de1acae"
    sha256 cellar: :any, ventura:       "6a9195d6188030391e30c5544a70d26fef4f4d205baa0a8757078e15bde4f241"
    sha256               arm64_linux:   "eb081b68896b699b5ec7c73e1e0cd8d4272293e0198ff65af6b56ac196543e2f"
    sha256               x86_64_linux:  "9f833fa6fea950b820f28e07d935da0ccb3707b4dc6b68f98b20936c50f4b982"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause "Requires C++17 features not yet implemented"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_BUILD_TESTS=OFF
      -DgRPC_INSTALL=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    linker_flags = []
    linker_flags += %w[-undefined dynamic_lookup] if OS.mac?
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if linker_flags.present?
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # `grpc_cli` fails to build on Linux. In any case, it looks like it isn't meant to be be installed.
    # TODO: consider dropping this on macOS too.
    return unless OS.mac?

    # The following are installed manually, so need to use CMAKE_*_LINKER_FLAGS
    # TODO: `grpc_cli` is a huge pain to install. Consider removing it.
    linker_flags += %W[-rpath #{rpath} -rpath #{rpath(target: HOMEBREW_PREFIX/"lib")}]
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}
      -DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_BUILD_TESTS=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    system "cmake", "-S", ".", "-B", "_build-grpc_cli", *args, *std_cmake_args
    system "cmake", "--build", "_build-grpc_cli", "--target", "grpc_cli"
    bin.install "_build-grpc_cli/grpc_cli"
    lib.install (buildpath/"_build-grpc_cli").glob(shared_library("libgrpc++_test_config", "*"))
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
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *flags, "-o", "test"
    system "./test"

    # We don't build `grpc_cli` on Linux.
    return unless OS.mac?

    output = shell_output("#{bin}/grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end