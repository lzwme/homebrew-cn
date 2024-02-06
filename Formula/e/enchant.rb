class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:abiword.github.ioenchant"
  url "https:github.comAbiWordenchantreleasesdownloadv2.6.6enchant-2.6.6.tar.gz"
  sha256 "ce9b40e22b3ee5e91ca35403487af03896f4deb1134efcf0b1b3ef9764d28295"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "e785e7b10d5d7e87d344bb0a4723ae0eaccbce5532d0edfead8389bccfbd5186"
    sha256 arm64_ventura:  "666ebf1fd00c7d115313619d94ffb56190ed30169eb767fc0c0666bcfa436252"
    sha256 arm64_monterey: "67be0873acdfdfa662387cead99b7ec4be825f80aa411d41be2e1f15e62c9305"
    sha256 sonoma:         "2aa6bc0bbdb0f0256b85d302908215d62280002dfdb9645528b4f0a70f8f2fab"
    sha256 ventura:        "14064383a0bdf4b8690506d773b651b41bfe99bbf11b94ae2ce4f305ecf25faa"
    sha256 monterey:       "bfa1c155a1f867b878765251ee1f4cd5a5f759f3274af05fc3fc7a89b6dff0aa"
    sha256 x86_64_linux:   "570e8eb95089d4b4ac5ae29ca683e8175e83ab503b9771ebdb12fca7e913e081"
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