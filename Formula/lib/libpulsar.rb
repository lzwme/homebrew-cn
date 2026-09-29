class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3095da9d53780d1d6ff1f06a44392de7df62880a6a3055d0bbdef29df8e6639e"
    sha256 cellar: :any, arm64_tahoe:       "de5d8dcba12c3e670cf8bb07c1afb282028163e0b399b6ea57979bd2d868cf2b"
    sha256 cellar: :any, arm64_sequoia:     "fb601ee13874282d298ab703fdccc171bac29f04c271b8653d21d833b02329d5"
    sha256 cellar: :any, arm64_linux:       "a6e3283fc5230ea5b767d6dc69c774607adbee5e750bb91d94c27a5556131f07"
    sha256 cellar: :any, x86_64_linux:      "4e871be02f880d49220d62dc62de9e5b4c4dbf20669419ebb2d9c08fc4c71b20"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}
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