class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://ghproxy.com/https://github.com/AbiWord/enchant/releases/download/v2.6.3/enchant-2.6.3.tar.gz"
  sha256 "c1c5719f2a597ce3e06c938cfb99fb697da093dea7b857cc004dc1dcf1bba182"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "a842f2cd99c827d7b45010379c7b2a5c496e897f0c96344034bc43aed1b73720"
    sha256 arm64_ventura:  "90069c7970e6c0b3bdd3671948e0f6536c0e9af4245ff10d439e6b6bfbb1a4a6"
    sha256 arm64_monterey: "b902f73c5230cf3873ddd9cc03f4048566d822595086dd1649efb6ae2d69ffb8"
    sha256 sonoma:         "1124c683705b1f590c519ed5196d19f7207fddb91e863829739fa6587e563ea1"
    sha256 ventura:        "b22e3089fe11d31d93dda19306571cb31cc01ca6a8e55e3e9aebb55be38cd8e6"
    sha256 monterey:       "abaff6669e71e859ec84194d74af22ab05031e48697af29dc550ef4d0a961981"
    sha256 x86_64_linux:   "426ab7143b11d036d1b44ca9aa1e05e30ea0e6e9d9272cbaecc5178ad20f9044"
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