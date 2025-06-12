class Librdkafka < Formula
  desc "Apache Kafka CC++ library"
  homepage "https:github.comconfluentinclibrdkafka"
  url "https:github.comconfluentinclibrdkafkaarchiverefstagsv2.10.1.tar.gz"
  sha256 "75f59a2d948276504afb25bcb5713a943785a413b84f9099d324d26b2021f758"
  license "BSD-2-Clause"
  head "https:github.comconfluentinclibrdkafka.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83ae6f0840c49eb81c73f8061f28dedf43299a69b217cb33dd498871669147f4"
    sha256 cellar: :any,                 arm64_sonoma:  "51e8271927eb0ef5d1460c988e47c8b1a9fd0ef3e5142fa80c51c639c4528a8e"
    sha256 cellar: :any,                 arm64_ventura: "c6a4b69a2a6c06309ddd9ddef2289b2ab6c061e77172ed6fb90878aba3dd29f9"
    sha256 cellar: :any,                 sonoma:        "62efd5b640361ef72fae11a941b2798bb6f8a7f029397931d562085c4e7ed3db"
    sha256 cellar: :any,                 ventura:       "7808d242df4afd1ba37760e63b13989e0f24d2e622e10a3bee62788069ce5469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c51baaf05dcf0bf081f47873a1afc0b5641053119f966ab9125a27ec352c9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8df8326852ad6da7d94cb8fdd5a260af791839ec8ddecf889b141894ddaa8e"
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
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <librdkafkardkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; * random *
        int version = rd_kafka_version();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system ".test"
  end
end