class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https:rakudo.org"
  url "https:github.comrakudorakudoreleasesdownload2024.06rakudo-2024.06.tar.gz"
  sha256 "467959f9d1e6c69e39089b5ae090fd100762b71deeb7ba594631407c34f5202f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "dac0949fb877a7864c63ce2c6eb1ab2cde0b5e9124af31c95e10b7745690c9e2"
    sha256 arm64_ventura:  "19c15d65471732a23fb1c6eb02916bf4866ebed9294b0ddc97f4b390d3a64112"
    sha256 arm64_monterey: "ac298f86de982e5ad0d81ce51283cf23baa88d0c7bfedafd9d2addec82ddf187"
    sha256 sonoma:         "c51f812bf4e4694d95099cd6ec123bbd0aa681167a658702d363ae5f48db1df3"
    sha256 ventura:        "bcb0af219c90488cab09e77814b35342e110ca08d9c5177646a66cba13d27676"
    sha256 monterey:       "eb936b701d60a333791db7b48a16633883a55743a76b6bdc9aedcf67771635c7"
    sha256 x86_64_linux:   "da9d540549432dfa9422b9c14d64aeda6bea78aaaf0d2ad8192a079e4888eb00"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}nqp"
    system "make"
    system "make", "install"
    bin.install "toolsinstall-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end