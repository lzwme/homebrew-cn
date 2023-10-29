class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://ghproxy.com/https://github.com/AbiWord/enchant/releases/download/v2.6.2/enchant-2.6.2.tar.gz"
  sha256 "6686a728e56e760f8dee09a22f0fb53b46ee9dbe7d64cf9e5bb35a658bff7e1d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "043c9e1569940eefb1cc045d2d4311d85139e84e85fd0f1fe03a7c5c6a1f4759"
    sha256 arm64_ventura:  "919a2dd33e64b62cd1ade814946c98b67651db2d2abd35befb324dcc55bfbb38"
    sha256 arm64_monterey: "f4f615e2436b80ed4294b07da9f177e83eff7b828772cfe063c4138e2b958be9"
    sha256 sonoma:         "27a5981ef3d92012086f20472365be6889584fcd245057345cd33514045e7683"
    sha256 ventura:        "4363aa246116d4341edee73b3efc98dbc1f503f9804d1ba352ff5c8fe3dad65b"
    sha256 monterey:       "20f42f4b6b84893b7257321931338d3472a6b1cf71256648a97707cfbf39dbb9"
    sha256 x86_64_linux:   "afa8a086ff6101d467fe18ffece1fa8592074f89a25d83aa5344c254201d0765"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
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

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end