class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  sha256 "8bad1ed09241ba62daa82b84446b3c45e9de5873c407ef09f533fac0332918bc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da5e0d952380677acf9a13a10806da29ec95496a71073f5fa5c6b27f99e2c98d"
    sha256 cellar: :any,                 arm64_sequoia: "00a5da9776e85be0715a887e13a26641c64b95e804422dbcdc0944bf391141ec"
    sha256 cellar: :any,                 arm64_sonoma:  "5556ffa54e86a0c83ea4995e8c917e132d38ddfe1563f5ff2f32c8437344d84c"
    sha256 cellar: :any,                 sonoma:        "76814d2ea3eebec34f4c7a69c753a7208775f4a72bb24ae34a0d73692abcdfc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ce988c8cf3d15169b2f2316f45540d8b4b0338b5838262a286150ac071d4836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb468bbe8a60600a1baa1861434896390f64285b86f6da041bf74011602e3e3"
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