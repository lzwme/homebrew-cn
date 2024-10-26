class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https:ugrep.com"
  url "https:github.comGeniviaugreparchiverefstagsv7.0.0.tar.gz"
  sha256 "5b24228ff4452d861bf1b2b0afa0232d13e8bee0289c1d1e963e7dc102eb745b"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "c65caa09983516dd11d543a3f09eb505d7c72889f9bd0cbbf427357a262ebe4e"
    sha256                               arm64_sonoma:  "4653f8b48069097384ae4b2c25a99a433a70899b71ae1db86ea834905ca763bf"
    sha256                               arm64_ventura: "35296e9295aebf0691754f61765001c204abfdb1e7c112966bda4514f75745d7"
    sha256                               sonoma:        "3622b0adbf6634851fa628a0d27e01c3dd492fb398b7e3796cca563d4cfebcab"
    sha256                               ventura:       "b279e705dcd025ab9cf1e8ce1da466549f771eff975af947587e5c5271f77105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec0b235fedda05420735d57afdc5a80c651d162e2596e69356408606b2fd3b3"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system ".configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}ugrep 'World' '#{testpath}'").strip
  end
end