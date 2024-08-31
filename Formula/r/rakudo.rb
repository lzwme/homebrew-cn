class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https:rakudo.org"
  url "https:github.comrakudorakudoreleasesdownload2024.08rakudo-2024.08.tar.gz"
  sha256 "1d93afafd289683676a17ab61b4b02bb7e358391d30e4f29a9a045baec868b71"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "4ddefcd1291cac711ced2ae7d5ee8995bea2afc5a9387405fc0238429bd64340"
    sha256 arm64_ventura:  "1e90e8fdfdc06e0d39bf4f2d92de22f86603b2394b1582e6e38c23335478a937"
    sha256 arm64_monterey: "870676e74fa6d3d319ec4b3567b0a3784d54c6639fe95f7bda9b2a9fe2ad543b"
    sha256 sonoma:         "7468192b0359754d67b2e78a11fe53745c09643bb666414db03c6b7c30d81516"
    sha256 ventura:        "e9b1f4cf28e5317a25f1de612157c640ac04faf34a6c9416557538e8c94a8a51"
    sha256 monterey:       "1d01d6876ff64bf18589d280334aa3bd3fdba78f8a4387bf1c700d2c3ebb3841"
    sha256 x86_64_linux:   "4da26095cd1e282d0093d100bc00086a8b10da3782751e2821f4dc9dbcc8229a"
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