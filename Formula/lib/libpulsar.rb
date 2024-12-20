class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "816b2ec9deccd1d19669f28e487ab75e05ea77055fcfd443f0dcd2dda83fabf4"
    sha256 cellar: :any,                 arm64_sonoma:  "969e691bd2630a3d97c9291675cd12afe9e1ff81f1fd66ad0f72bcd3cb0c5d38"
    sha256 cellar: :any,                 arm64_ventura: "9fd142a31a4306e8fcf0d48b958310fd58b555aea54d5caa8d6df698e7d70254"
    sha256 cellar: :any,                 sonoma:        "e7269ae02774170efad469b1ba26906b0d392202d6b0e5a02c8c1a166c9739a0"
    sha256 cellar: :any,                 ventura:       "80379aa8ca491a0af30530e8cb27e7c821d4072d4752ee09d61bad51171a15e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab75ee9e7f26b90493dc4fb98f7f1b71d5decc400a56a4a3d10c9caf297ed8c"
  end

  depends_on "asio" => :build # FIXME: Not compatible with Boost.Asio 1.87+
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
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
      -DUSE_ASIO=ON
    ]

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end