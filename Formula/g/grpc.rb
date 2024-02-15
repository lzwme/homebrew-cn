class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https:grpc.io"
  url "https:github.comgrpcgrpc.git",
      tag:      "v1.61.1",
      revision: "5174569c4d3352112848f1b86ba259425db939cf"
  license "Apache-2.0"
  head "https:github.comgrpcgrpc.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sonoma:   "bafe2515e2b4598ca9c65eb1ddb144ffafccfc7763834725a9f8abb6863a7901"
    sha256 cellar: :any,                 arm64_ventura:  "15e48b426531b60df77325529e348f4b64a236d9a10f6dbc08c6beea43ff611e"
    sha256 cellar: :any,                 arm64_monterey: "c4830f1c8d56d21e1eb4b185b05ea37527cf0b01363552f620553ced112fd2c7"
    sha256 cellar: :any,                 sonoma:         "0c9734126344462edbc8403dbbb789a3ffd9b7cebda6096cce0ef2c6f06cb70f"
    sha256 cellar: :any,                 ventura:        "dbe94679c9e38dd7ff4496bab9aa2bc387b476265da87ad80e52b4aba8a67a04"
    sha256 cellar: :any,                 monterey:       "ad139fbb3e259dfd5ae93f846f0d1a60ad1ecedd19b2464f482368722d9880b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c705544686673d6484e7c3a0f0b3d0523e27ce2e46ac61ce90514e72acfce191"
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
    mkdir "cmakebuild" do
      args = %W[
        ....
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
      ] + std_cmake_args

      system "cmake", *args
      system "make", "install"

      args = %W[
        ....
        -DCMAKE_INSTALL_RPATH=#{rpath}
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=ON
      ] + std_cmake_args
      system "cmake", *args
      system "make", "grpc_cli"
      bin.install "grpc_cli"
      lib.install Dir[shared_library("libgrpc++_test_config", "*")]

      if OS.mac?
        # These are installed manually, so need to be relocated manually as well
        MachO::Tools.add_rpath(bin"grpc_cli", rpath)
        MachO::Tools.add_rpath(libshared_library("libgrpc++_test_config"), rpath)
      end
    end
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