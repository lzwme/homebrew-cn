class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://ghfast.top/https://github.com/rrthomas/enchant/releases/download/v2.8.17/enchant-2.8.17.tar.gz"
  sha256 "ee40256e271d0bc1f212ecbc8b8d3da9066b33c9ca987d266759665eb0ca694d"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "efb1d33811f719935cda5e8cfd723bfa7d46711649d07145370ada794f94ea47"
    sha256 arm64_sequoia: "b1628f834a4b5f9d687790ccb70f337a977dec716e6192cebf7967bf3b310ca2"
    sha256 arm64_sonoma:  "84369c8b9ba3d5be7d8449e1ed5ea17c7c41e73564af393a4ce200dc76b6a70f"
    sha256 sonoma:        "e3995bee16d773e959879463ad75375e17b8bba32a232becd5fb7c430dcf0c4c"
    sha256 arm64_linux:   "84aba5cbce1ecf71d8756f7a24a2e108c52a506293654159a2af1739dcba5014"
    sha256 x86_64_linux:  "1e41dffb13510f0bdb7c0633418b843dfc4b8cd2f7365f1ccaa3aa27a2612dac"
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
    inreplace "src/Makefile.in", "groff ", "mandoc " if !OS.mac? || MacOS.version >= :ventura

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"
    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text

    # Explicitly set locale so that the correct dictionary can be found
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end