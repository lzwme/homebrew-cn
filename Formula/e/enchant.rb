class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:abiword.github.ioenchant"
  url "https:github.comAbiWordenchantreleasesdownloadv2.7.0enchant-2.7.0.tar.gz"
  sha256 "2a073dc6ebe753196c0674a781ccf321bed25d1c6e43bffb97e2c92af420952c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "85865b4312f059619c0a24af06dae587548a7515d2de2c6cc2322eea874ecb3a"
    sha256 arm64_ventura:  "1f00f810652e806060ceb85a846b813abe5e67022c8a7480a6476a61fd8ebac4"
    sha256 arm64_monterey: "11b235d67a2a531ece59d46c405267e1d86e9b872b1638dff4707831c847ea9b"
    sha256 sonoma:         "3ed4ff44fc927748d3edcb90ff663c1cf313ed378ecc1a2aa5452afa6c05559c"
    sha256 ventura:        "4b2b7de08be8afe075c103c26e2d4485af998aa21a0fd9774dba9a2390f223d4"
    sha256 monterey:       "c3e231a96dde7d04eee137bd65282eb47b32e2069ad30f9df02e60d567ddf608"
    sha256 x86_64_linux:   "46a0c5d16a05152e09f3e3fc4f409c5a4caddebf12fecb8e49bd5b7c20e9b7ab"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

  def install
    # mandoc is only available since Ventura, but groff is available for older macOS
    inreplace "srcMakefile.in", "groff ", "mandoc " if !OS.mac? || MacOS.version >= :ventura

    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"
    ln_s "enchant-2.pc", lib"pkgconfigenchant.pc"
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpathfile).write text

    # Explicitly set locale so that the correct dictionary can be found
    ENV["LANG"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}enchant-2 -l #{file}").chomp
  end
end