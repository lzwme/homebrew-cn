class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.6.0/apache-pulsar-client-cpp-3.6.0.tar.gz"
  sha256 "522ca67bc911fcd4c0c9e4278628c9167b614a887c63fb04b04370156254d3b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "307ecde89686ced5cfd3f69a6dd653a4e8727c719740aec0bab0fcebf9611f97"
    sha256 cellar: :any,                 arm64_sonoma:   "c3a40c4fb6c7207494ef089b2c786d7d241998ec4eba507b60d4c9be6ee9ae5f"
    sha256 cellar: :any,                 arm64_ventura:  "79d49033ef99c7d7f34292310547d1e19fc25f6e62fe7e41b5acb2da2fe55b85"
    sha256 cellar: :any,                 arm64_monterey: "2779bc0a62b6b5da15100c6f421535037d8bd758db7d0dfaff2b8e052887de21"
    sha256 cellar: :any,                 sonoma:         "f40e743f0764698b708a28200519a98573e25f69a80c84578028f3b0801adb8d"
    sha256 cellar: :any,                 ventura:        "b81026ed363b17aa348054149fab4b0ee8a082a3de05caace47b2b50f26d3462"
    sha256 cellar: :any,                 monterey:       "9a37965b41c5b8980f4a1f67c0f95f8cdce1d3592f5a7485b3b6b1e4c057d533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062739d54ce8bc2629559107fd171d9b8c84f7c9b2e5224865747e7e474eea73"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "boost"
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
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end