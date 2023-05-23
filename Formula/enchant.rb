class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://ghproxy.com/https://github.com/AbiWord/enchant/releases/download/v2.4.0/enchant-2.4.0.tar.gz"
  sha256 "07915603f4f6889d5caecfddea58a16c1565f340f49c428a7bb7686abbff816e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "13e25c1cc6981019ad767abe8f9cfc813e50e87e20be3ce2c8518b2e3cc2f86b"
    sha256 arm64_monterey: "7334d0067f00e243eac8c887b18f4267a4347326bb931f3575f2a99eb9e01212"
    sha256 arm64_big_sur:  "876a00a507ebbadf72278bc42a804f54084e210621eb188f81b01e25af176ecb"
    sha256 ventura:        "3f77e2424648125ab1fd3ccc8778cfffb867992531eb6729fce51d4a65535750"
    sha256 monterey:       "5129e4979fb6acd489108b61134bff9bad1392691eda42ce8136c43f941f2876"
    sha256 big_sur:        "51eb4bf52e7fa68c3d14989e39f749ae02655a19d2f10205710e7781271d1fb8"
    sha256 x86_64_linux:   "7839dd890a475037016b5c97333871a86d20cb56d866e34de8c624dfa51cb047"
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