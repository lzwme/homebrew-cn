class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:rrthomas.github.ioenchant"
  url "https:github.comrrthomasenchantreleasesdownloadv2.8.6enchant-2.8.6.tar.gz"
  sha256 "c4cd0889d8aff8248fc3913de5a83907013962f0e1895030a3836468cd40af5b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "d2a121346d5e2ce84253e9b5fa56dd570f53010167b40028d224c3c0fefe8ec6"
    sha256 arm64_sonoma:  "24045952075732a80dc14b18a06578f7b6156f55d6cf44f5f85014320fac7b83"
    sha256 arm64_ventura: "81a49deba1f0c1247c98d489e1061f7212c5505e1685d50175176691e04f49e0"
    sha256 sonoma:        "b32557b6d6b131b9990295cee2728d2e3fe0a0c191eec9ec47f45312d151a1cc"
    sha256 ventura:       "8e69f932af27dfa36c378aeed7a2a2e9a4636779dc7c4ba29d17cd9512eda8e8"
    sha256 arm64_linux:   "34be348f12fbc3f9c31a8bd91ca0dffc1330601740b2185ca6aee4daa89b9e20"
    sha256 x86_64_linux:  "a1ca40d62fa92d578e7a0b226d0a35133961956048571eebcabf5e0d9b922ee7"
  end

  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

  on_macos do
    depends_on "gettext"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

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
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}enchant-2 -l #{file}").chomp
  end
end