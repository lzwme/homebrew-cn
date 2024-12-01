class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4fac16d2bf278f0519bb4354877e23b9e88412c981c441c34c9167da47b5331d"
    sha256 cellar: :any,                 arm64_sonoma:  "7874d033e375317c841ca143859a7dd7b70cededdb3fd16cd414d264cc227653"
    sha256 cellar: :any,                 arm64_ventura: "dcea2dab811fe018350cdf60b54c60b59c86b655dd5245b8dfc9235bb677fe2b"
    sha256 cellar: :any,                 sonoma:        "3432fd7d9fb9f42fe8c80338f54853dc8c8bb2161e5cd8ee577cc9af90fc6cbd"
    sha256 cellar: :any,                 ventura:       "de205eb068098f844902d4f670560752cb0ecd06e816406421bf2d13806ca4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abfecb71a4b5cfa38dfcca2c4c82d1708b40c6c3c500905943de99ab9d16cc57"
  end

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