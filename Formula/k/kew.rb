class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "d5fd38cfb70d1fe87853acbd6e4013fc60041a7218ce9d87d12fc9b5fe82a4ea"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "535d48a2eefbada63e0738813959dc2fdabc4705da0ad5d38f5f3ba348d2e021"
    sha256 arm64_sequoia: "ae14e926c91740dadce4f9174728fee026f799bdcdf2ae118abe3a80e317514b"
    sha256 arm64_sonoma:  "aca004072ae5f2f08ac09ccb36ae18fb4317cfb50036c9deaa7c7c51e7d49e52"
    sha256 sonoma:        "446373f96544e0aaa6cb8aa86aa917df45d414e693081d42e89bbb4d99cc9926"
    sha256 arm64_linux:   "0c351c25de51aa45a5cb925656258091cfb2d5dc284ab1c6504f4d051ef3a830"
    sha256 x86_64_linux:  "86d9aa5b050a31daad37b05c013a09f0b65524b00938a6e1edc88e6650d82e3d"
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