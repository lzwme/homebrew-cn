class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://ghproxy.com/https://github.com/rakudo/rakudo/releases/download/2023.10/rakudo-2023.10.tar.gz"
  sha256 "a219aca078b99002fed7b3fa2c2e280457224cf581e9a27af44bcb5f9c8dc160"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6db0150adbbb18859cebb36fc7ab1e58a549575837b97ea7374c7d30091d1798"
    sha256 arm64_ventura:  "a0b2b99d63310fabb83e9a1db834d6bddb13bf65bba25bcc82c8d951a06ae7f1"
    sha256 arm64_monterey: "f866f821c1d8f9b53a46ddca52a2c8a23680db79137e5e7aba07fc6b90ae305f"
    sha256 sonoma:         "117bcaa0a3994381764caab9595a74d71e6b23093bb5e068ac18c72da5324ea5"
    sha256 ventura:        "fb2ed565b5a937046bf9aebd83d8f76a19cd22e905e816fcba013b8237202dcf"
    sha256 monterey:       "6757040f589fc0e5350fff6db69835692f2c4de264e72fe4b87544f913e1c200"
    sha256 x86_64_linux:   "71f874a82d552a4edb6007e37e0e11d1e331323d72af323450477879acb3af3f"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end