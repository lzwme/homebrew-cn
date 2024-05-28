class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https:abiword.github.ioenchant"
  url "https:github.comAbiWordenchantreleasesdownloadv2.8.0enchant-2.8.0.tar.gz"
  sha256 "c57add422237b8a7eed116a9a88d8be4f7b9281778fa36f03e1f2c051ecb0372"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "99a566bf3799835e3f03c09478f72a1ed6c85bb87b949ab096427213baf7eff8"
    sha256 arm64_ventura:  "150d5f44ab04c99505b05484a530e97ae0168f658c14373af4abe74ac410a4c4"
    sha256 arm64_monterey: "bc50ecfba20785e62cc892a9447a881fb51574a6a9836765330b94b85e5fe0b7"
    sha256 sonoma:         "176c580392902310c2ea93049ebdf8ff8f166f1bc2e80d314c9c0394d5cabd87"
    sha256 ventura:        "411ef8ce0cec999967098f178d884daa0e8989aff20d5783ca4ffcb7fb7e4d74"
    sha256 monterey:       "56a6d440d52dc5469ea2d5e2a7599a4adb48d986b93119e6725afc2567be0259"
    sha256 x86_64_linux:   "d08560c3597f934dc7362f33d10ec1f206dbd0e538650dcd64fc5d0a57491c27"
  end

  depends_on "pkg-config" => :build
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