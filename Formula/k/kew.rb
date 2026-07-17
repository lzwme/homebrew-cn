class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.2.6.tar.gz"
  sha256 "c69af6a1f373f4f00e05e5f60b2457da471391355fc2a920d2e275c3baa40443"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6fb0fcb90c41701804b1807753414dbc223bd8947845ce24a954ff3557670f0c"
    sha256 arm64_sequoia: "fa7b7d2e1752d8d939b06b958e8fc45e0f1444472a682149d45441629f209622"
    sha256 arm64_sonoma:  "9a411572c25f5fa3f0cb3c452ccc1e26676132ea4fe4b999a22e97765af5d9a5"
    sha256 sonoma:        "ffa8732855775fcc51ec38af7294eef8b7613f6a8e6920982c4dbd3dfaa9bd9c"
    sha256 arm64_linux:   "b6aefff8dd26335cf73cd01f955213e7402e60fb01f08e8dcf9ef42cdc201730"
    sha256 x86_64_linux:  "dbaf5271b9948b45bd1719a76736935226549c38e856af8f15f207dc92ff2f18"
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
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
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