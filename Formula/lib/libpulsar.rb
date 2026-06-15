class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.2.0/apache-pulsar-client-cpp-4.2.0.tar.gz"
  sha256 "cc48a168dc44dc2f89122edd692c2919736c794564c8a71c6a7acff86ca2d315"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10b77f3b2de1503b6ed4901500e643da512055065093c797622f416f20f5cd7d"
    sha256 cellar: :any, arm64_sequoia: "67f4a12da7f33099f9e7825f04045e3116da365e46546db3e38120fdeee7c8f4"
    sha256 cellar: :any, arm64_sonoma:  "7a78eeffd3df24270fd1973d7f39f491c64d833685acdc7219deab85934eb7ce"
    sha256 cellar: :any, sonoma:        "60482a07fb6acf85e7965896bfd09da66f214cab5146f5ab647369a509797d98"
    sha256 cellar: :any, arm64_linux:   "3d238a86ea5fe22b75245f23ca940d818fb551ef7c25316421e22b32c2b802f9"
    sha256 cellar: :any, x86_64_linux:  "be1b6a41d3178ab8186d0cd8438c30eef27e3188a972894d08e34c95aa290fb6"
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