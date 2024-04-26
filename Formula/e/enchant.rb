class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:abiword.github.ioenchant"
  url "https:github.comAbiWordenchantreleasesdownloadv2.7.1enchant-2.7.1.tar.gz"
  sha256 "a1cb8239095d6b0bd99ba2dd012a1402cef1a194f5de1b7214bd528676a65229"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "435257bac6e313e43a12c59f204513a064b938c430e275ee775b595fdd2d2572"
    sha256 arm64_ventura:  "07ff657913a51b3f7fe27371b84cbd3a06fee8b4bd59f3c9193172755e023344"
    sha256 arm64_monterey: "84748cb2c58723ebbbba3dc30907df1047c0e66f5f233037e703f1999f64d4a5"
    sha256 sonoma:         "a63d4a10b565c140d06901c695bb946db8f8947eebcb3ed12f7246019b6fcc6e"
    sha256 ventura:        "cb5db1009ff7713e7290cdd3909c64cce53909556de75bfdbc31be7906388e13"
    sha256 monterey:       "d8bba432d0d531f25eb989f96b6ca4bc5796347194668b82c29623b6a195fd93"
    sha256 x86_64_linux:   "184b0903b43c897678bd0898ef18e30c9aa1b9d26a996c33a171d42e096aeacf"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  uses_from_macos "mandoc" => :build

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