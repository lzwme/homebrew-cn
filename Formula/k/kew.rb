class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "6d4cdaf32ecf08d0776869e311e650f762f7fddba2afc1921134441b3f23afa6"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "2253cbc3eca181c43dcfc9354f55784bb5ce86395c63ccc7d4bf96d4bd444c7b"
    sha256 arm64_sequoia: "240b4e4f420e01b494e67fee41e1f39c179ac9ac51086bb088190dab2f0c0e93"
    sha256 arm64_sonoma:  "c465cd94a7fc95054a88ea9cf7052162073f002eec790e9ab57d1121ec75213e"
    sha256 sonoma:        "44496088d4200ca1687ba81d8f164a3fc66d6c90676ca97749e2b30eebe60b3e"
    sha256 arm64_linux:   "3e79bc459782c30eca7f4f9df9e62023445673b1b6641cf86e36410bd1be5d55"
    sha256 x86_64_linux:  "225f5247045a168a52e87d71f070226a7fb8fa661a1017d2a6821443e8535d4d"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end