class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://rrthomas.github.io/enchant/"
  url "https://ghfast.top/https://github.com/rrthomas/enchant/releases/download/v2.8.13/enchant-2.8.13.tar.gz"
  sha256 "15d78f09119bb256d7fbaf03e4e4910bcb0d5333b9105cc398475e88668e8cb3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "df9f6cbc6602c4583a74587b20c8fbd7bb5bae53c2e7b24db9acf51c6f53502a"
    sha256 arm64_sequoia: "0e282b29cbf57fc0ed843134f3a4acd49f0ebd88cfb0857285e2b95ff0e6c8fd"
    sha256 arm64_sonoma:  "38774a9f07570901d77cd5644c475c004fc3af9d8609445b0af42d3923f1d6ac"
    sha256 sonoma:        "1d01753dd8fba95dc9c5aa8ed65820f21bd1fbbaa725f1da27f8491e1ff97c21"
    sha256 arm64_linux:   "f8dd03bac1312c3bd4c6b4dbc5cb2fcbc08e9ea14a3acfae313a24689270f0f6"
    sha256 x86_64_linux:  "96d7171fc8d522a7689876bb98ebf9e2e5426f8fb78e70773d4563177cac7148"
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