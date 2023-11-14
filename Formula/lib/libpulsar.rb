class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.4.0/apache-pulsar-client-cpp-3.4.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.4.0/apache-pulsar-client-cpp-3.4.0.tar.gz"
  sha256 "b4dfb0608d1b0b11250cf4213fa223c463f71f4c8e8e068c5bf49e35bfdcc020"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9a4ecbb4a655031e0f1feabc3ea152510ccf74200a59f49c90517dbf0d62d70"
    sha256 cellar: :any,                 arm64_ventura:  "336428b9b2d210ced13003e388b582e544e9f67cb43b989145f96b8d81a1ee79"
    sha256 cellar: :any,                 arm64_monterey: "1ccd2c273edf5bbf0a853d00b620030c5001ba34bfe3943cc28c69228b1675e2"
    sha256 cellar: :any,                 sonoma:         "0300f57c436736a3390514ded97b5d6a770e3b81dd351b49a5d8bad7239565be"
    sha256 cellar: :any,                 ventura:        "584c405c39afc47aae346508caac1e90aa79a35c77144965ad12b50c78ea8ce8"
    sha256 cellar: :any,                 monterey:       "f71b847dc3aa2cc66385f56330821895ce848f3ee4c78f1c41f1fb75e187d110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16346e16a1a446b3e34fb0b28d83c6151cbb50856befeba1ea166ce01b4a3590"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    # Needed for `protobuf`, which depends on `abseil`.
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD 17"
    system "cmake", "-S", ".", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # protocolbuffers/protobuf#12292
                    "-Dprotobuf_MODULE_COMPATIBLE=ON", # protocolbuffers/protobuf#1931
                    "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                    "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                    "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib/shared_library("libprotobuf")}",
                    *std_cmake_args
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