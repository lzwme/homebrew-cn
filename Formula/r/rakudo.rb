class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https:rakudo.org"
  url "https:github.comrakudorakudoreleasesdownload2024.10rakudo-2024.10.tar.gz"
  sha256 "fceb6aa9493c3c870d769152b3fac362af68b8f09a44da681f166eff54ec9050"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "600fe34f28d6ba7730b2f777636dff3d664cabf608edcc57c7b5a02dc513c055"
    sha256 arm64_sonoma:  "bc52052f74c0e3e1f567378bf50252d7271c3db295bfa9b6381b2cd1460564ec"
    sha256 arm64_ventura: "a9c1c1c2fff9598f7838a387814f88e66b7f8e3bd5ca01a52e203434341b7e27"
    sha256 sonoma:        "8604a5066d586004a8300b50d2181985baab1e5e7ef19fa7c4b200ea63b2637d"
    sha256 ventura:       "9e1aa83a84de9268303f2e34a6447378111639aaa5a9613533162ba89892574c"
    sha256 x86_64_linux:  "b37e039bf1d44cb6c3adb86db4982744bc5d43b1b0e735170404c91c7998c045"
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