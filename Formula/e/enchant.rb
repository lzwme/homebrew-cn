class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:abiword.github.ioenchant"
  url "https:github.comAbiWordenchantreleasesdownloadv2.6.9enchant-2.6.9.tar.gz"
  sha256 "d9a5a10dc9b38a43b3a0fa22c76ed6ebb7e09eb535aff62954afcdbd40efff6b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "8ae5eb2d204a14780d6bfd6a707a3fb182a87d19e66a60b74fcbaf550d443716"
    sha256 arm64_ventura:  "4e11d762a4b73dbdf34abd7bda9b45087d092d4e1fc727551b11d3c552527f2b"
    sha256 arm64_monterey: "0408083f5fb77fa4ae68a9e89fef6ba2069c2daf3f45b6446dfe3f6820b9bd88"
    sha256 sonoma:         "8499ad0376679963ccad9125720df47181e6e0069445b2b9ec1dfd25a9352f49"
    sha256 ventura:        "d95aaed76be7564b9d26e42dad0354f4022460f8fd9e0db9e0c17090e6a99590"
    sha256 monterey:       "8eacb51ac8a5e15a1e2c775023e4a7f9c037f6ea369ac1d25028ba4ac9987521"
    sha256 x86_64_linux:   "45dfca538691158fab2c71a5f533f653489a661829bc35de1e6b445e2d7bf254"
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