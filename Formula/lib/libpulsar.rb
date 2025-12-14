class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  sha256 "8bad1ed09241ba62daa82b84446b3c45e9de5873c407ef09f533fac0332918bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4484abf642d604912a93d4acb4486c1660873a156b324cbe389d2fb7f528f460"
    sha256 cellar: :any,                 arm64_sequoia: "32c8a45d86d01dbd6e09215493d42a1fb74d12f283f31f8736042c9ed9cfedaf"
    sha256 cellar: :any,                 arm64_sonoma:  "01ae811c6a55650199fbeb469fb01ebce634b5acca1a60f746db5a6ebec2946c"
    sha256 cellar: :any,                 sonoma:        "63677fbc61e7bab1dedd878286e264931b21da4bdec4af5847f7e5d9f92940ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6faf9ade1e8aafdd1387b5c19c062d5191755165e5572b8d6a27a1722ea2ba06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e22ebd5aa7a6b414c19c817b31bc3074dfa5bf16e0c2ab5d6fd922c00300528"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end