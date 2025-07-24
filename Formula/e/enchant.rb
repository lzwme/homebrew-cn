class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://ghfast.top/https://github.com/rrthomas/enchant/releases/download/v2.8.11/enchant-2.8.11.tar.gz"
  sha256 "fc6694a496848fb1204169c0cc6b844beec49fddd547bbf2bd2a7e33322c55d9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "0e113ff079f03e879b9da02c2ae4b4dcf6f73177967dd384ef6e93d026c8b1d3"
    sha256 arm64_sonoma:  "4022328b4f00ec416d6b672ae32163072e47a2938c9a239f26716ea33b1bebba"
    sha256 arm64_ventura: "0bc92fa461e55be4482dd6767cc02daab67d47143280551378eba13fa6a38855"
    sha256 sonoma:        "764dba2ef12123a3996662348a04a18c46e7840f0162b82af23bafa403338ced"
    sha256 ventura:       "baf33a2f1433531077d11233e1c58ed2bdb70415e0219bab72a19dbe37ffd788"
    sha256 arm64_linux:   "f11dbceb44432ce359c8554db576e3da81ad6478ca3a363f887ab56b3787c7c1"
    sha256 x86_64_linux:  "72d3aa5e5d6dedfe8686e6f3a94ea6bc55dbdca22b06809a731ca1d5deddafaa"
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