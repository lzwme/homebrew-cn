class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:abiword.github.ioenchant"
  url "https:github.comAbiWordenchantreleasesdownloadv2.6.5enchant-2.6.5.tar.gz"
  sha256 "9e8fd28cb65a7b6da3545878a5c2f52a15f03c04933a5ff48db89fe86845728e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "2f6ebb974294d7a2988bdc2370caaea6eaaec09fcb87d139f50c7b5e0c40b01d"
    sha256 arm64_ventura:  "5cc674e7b7852108599e9e295cf49f0f46a23a87c78501e7c7162c6df38ceecd"
    sha256 arm64_monterey: "6a6f1e2de8b1bd9ec6e4a1b06c43dc8c3e9a7e98b19e4ccf31c8b7c9415e98d6"
    sha256 sonoma:         "a1290594f27a384f77f098e597d3f184e673046f33318fe613c8e058048add16"
    sha256 ventura:        "3c24129404530866a4171bbd4dbdda7253a1b2ceae1e330e36e3e3f382e6672d"
    sha256 monterey:       "0bcc753d0c4194f9dcd433f0fe52ebd5351c86a97f70a887c811d73135e33714"
    sha256 x86_64_linux:   "2015903c42fbba97a717e286a115857eca2862884890885043497959e04e551e"
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