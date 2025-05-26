class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:rrthomas.github.ioenchant"
  url "https:github.comrrthomasenchantreleasesdownloadv2.8.5enchant-2.8.5.tar.gz"
  sha256 "27bf35078dddb9746ef040a9fc5bd07fc3f6be6e1ee082d4d7e00d09c524d89a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "be7396e42ed8b951ee3ed5e4fe3971a4d983ea2a53f460a4c72f84518854e679"
    sha256 arm64_sonoma:  "9fc09f40fbe82b2068ba2c2992ecebe881779e30f99ab79a0be7fe7b55a0d779"
    sha256 arm64_ventura: "54411406d0539d7f36932b34063a08c5c5cb314f9a33793f65f52579b5d0290d"
    sha256 sonoma:        "47432130b7bdcc8de9cb3d23c6170a1786df62a930dcf0e7745def5380e8629c"
    sha256 ventura:       "f8187ea209583e7c3725b8b0d4aa584fb2331269ff6f286d3b32475dbc75c6f6"
    sha256 arm64_linux:   "61b0222bc0849fa24cf26a64286f6d507ee8a26bd58863484f8e47f943f83c13"
    sha256 x86_64_linux:  "18bb06ac0a371d8271637a80c89e084860d505841ff7b4b72f2cef8fe3ccc60a"
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