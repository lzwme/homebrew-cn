class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://ghfast.top/https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "3bd351601d8ebcbc99b9a1316cae1b83b00edbcf9411c34287edf1791c507600"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ef4ed6a6b8703b96f1c1cff9b37a7fd9fd04aec3b84a99a970592901da5fde8d"
    sha256 cellar: :any,                 arm64_sequoia: "2f92c7d40926bcd61bc07b3f203501b47dc4251022349f91e07b8724fd897a3a"
    sha256 cellar: :any,                 arm64_sonoma:  "630d6b598109306eb4443d3be91a31730fad218cf23379fb6dd10eb61cd1e19b"
    sha256 cellar: :any,                 sonoma:        "b51d0131288d7786d316d109d716945c56f6f9e0a0b7b8cdce5c558d3d1d0840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9660ccc2351c20768bc5c021a33e9adcedcea5a7e0341dd1c41057ab5dff5965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be2944c5b1c1c8b9c6f649d8e0b0cc2cdd62b65ef0f1b04d07b3ca893fceea4"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end