class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https:rakudo.org"
  url "https:github.comrakudorakudoreleasesdownload2023.11rakudo-2023.11.tar.gz"
  sha256 "09ac43eb6b9eb7ffe363d098ca7b5b522896d85d78319e2cf832fb365f24fe32"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "6e62bc19fffcd92e54a5baa9cdd0bc04b7b9397b8a3367f414f9cb953faf1c81"
    sha256 arm64_ventura:  "9d1ed2ac20ceaa4857445de7aca36e9d59db42076d1c9e283b18c499dae53ad5"
    sha256 arm64_monterey: "07e527f22f3b8116d15a20866ce84949c9423a50d4d3b0a47ee572e4006bf407"
    sha256 sonoma:         "d8739402519a81f8fa15391b7e5d0a49ca3a34d44ab367c696629a59a86e2b08"
    sha256 ventura:        "bc76579dc99c07e71c03b20415854ee79b76591b2ac11e43b3cdb205c82b3640"
    sha256 monterey:       "c8a5c630d5f237d5c1d6c0e449ff85f1fd809162830727bef19dea1c955357c8"
    sha256 x86_64_linux:   "200de8ab11dcc86c04268a26b4a800458b409976fc7ccd58d38564862d45ce6e"
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