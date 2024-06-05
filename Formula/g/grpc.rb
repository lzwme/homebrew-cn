class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https:grpc.io"
  license "Apache-2.0"
  revision 1
  head "https:github.comgrpcgrpc.git", branch: "master"

  stable do
    url "https:github.comgrpcgrpc.git",
        tag:      "v1.62.2",
        revision: "96f984744fe728e196c11d33b91b022566c0d40f"

    # Backport fix for Protobuf 26
    patch do
      url "https:github.comgrpcgrpccommit98a96c5068da14ed29d70ca23818b5f408a2e7b4.patch?full_index=1"
      sha256 "5c4fc4307d0943ce3c9a07921bddaa24ca3d504adf38c9b0f071e23327661ac1"
    end
  end

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple majorminor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd78ec0460b1269edbc2aa47282faf2daf46f10dc02fb781abf32ca5ec435316"
    sha256 cellar: :any,                 arm64_ventura:  "19c6f0d64155fcae8d0c77e17c7aebf7f447170d96be5628da7572534ec07a1b"
    sha256 cellar: :any,                 arm64_monterey: "f8d7724d42bb1fbfd9adea821d62d263f1ed2c4e5212187adb5851073dc6febe"
    sha256 cellar: :any,                 sonoma:         "f6dd4fe57456027312842df9ff7e770cd1f1810a2eeec448d5a7a94d9722c182"
    sha256 cellar: :any,                 ventura:        "f33937b659881b3cc3d6b414b1523f972f93673ee3b57c941a176f3b253fdb23"
    sha256 cellar: :any,                 monterey:       "e41e879279a0e2993c47a14688c0da26846cf946635bebbf1b12042d3b2be5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e8a67b1a4fd49780772e3b580c4784ef1692feb590a1fccf57fc0d056b4e27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :test
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

  fails_with gcc: "5" # C++17

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
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # The following are installed manually, so need to use CMAKE_*_LINKER_FLAGS
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_BUILD_TESTS=ON
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build", "--target", "grpc_cli"
    bin.install "_buildgrpc_cli"
    lib.install Dir["_build#{shared_library("libgrpc++_test_config", "*")}"]
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <grpcgrpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *pkg_config_flags, "-o", "test"
    system ".test"

    output = shell_output("#{bin}grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end