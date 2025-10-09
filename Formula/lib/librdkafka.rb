class Librdkafka < Formula
  desc "Apache Kafka C/C++ library"
  homepage "https://github.com/confluentinc/librdkafka"
  url "https://ghfast.top/https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "1355d81091d13643aed140ba0fe62437c02d9434b44e90975aaefab84c2bf237"
  license "BSD-2-Clause"
  head "https://github.com/confluentinc/librdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c44cca1283a8f03e7805fc2dbfb36497c2fd7e598ef6fa158b2c2995b7f1c63"
    sha256 cellar: :any,                 arm64_sequoia: "45cd45b11131dfa8ce9914ae97b3a4f5c819fe79ea0f23b580cc996a7a307135"
    sha256 cellar: :any,                 arm64_sonoma:  "1dd8e19f5761d90d5f93ab7de6323d6ddc6b7c112592efd1224d57bc50ccbfa8"
    sha256 cellar: :any,                 sonoma:        "1201b18411b16b0b354ef84d06c230af7f712f892b06be8bac0c1d39276148f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5178668f370b60760fadd8aa1cc9b2352e1943c02d05d806ec8d187ed90ef530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8996fe7e947b35da5428a4b048050d9bd2a1417062d67331050e5e463ad21b"
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

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