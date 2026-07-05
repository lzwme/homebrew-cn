class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://ghfast.top/https://github.com/rrthomas/enchant/releases/download/v2.8.18/enchant-2.8.18.tar.gz"
  sha256 "883a16f0898c7b1af38046d8bce5c658156698498541e9344c60e317e8d48f2a"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "71e4cea24fe2fc824ffe00204570e8084891b6adaf379f629b7bac8b5b06919f"
    sha256 arm64_sequoia: "80beea2102bb9b4a9121752078cd96557462d8c377e27c934d0e7c80ef29992f"
    sha256 arm64_sonoma:  "4198951592187f0e1c30d7a62e3cef99bb64f4e1b8080b44cbe85f3f7ac2f2cc"
    sha256 sonoma:        "87f73ef98a1bdc30206baacba57b3cd4058e0b0bac4612904ca61921c54789e8"
    sha256 arm64_linux:   "a09003c67357eae55cdbc873cc50490c7ef01b63edc1c5fdfbcbea7b6afa2c63"
    sha256 x86_64_linux:  "f2245beb637993a2f91fe79ccbe5361f14926b6615c2051651f34a4e7bc299e6"
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