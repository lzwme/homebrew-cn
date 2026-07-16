class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.2.5.tar.gz"
  sha256 "a17f4acd54c78511bb14fc4e02aaaafc351f640388c3d29254f4397edfdc16a1"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a0a1f0c3465d12d39a1575a0b365b2bf133d004b3d86121ef248102f4e6de5f1"
    sha256 arm64_sequoia: "b810d585eecf176070e6c4f209d4f94997984ba6ed7f13cde9183a6564bb88c9"
    sha256 arm64_sonoma:  "62540b60fe6a16d8ba225e74b7293854370ee9c8a67d161d54c062bdbdb51ec5"
    sha256 sonoma:        "7d22a61fb687211b6053de7eed04d28858c350559912233494b8efd4c4a99b6e"
    sha256 arm64_linux:   "b1fa716856865cd4f035704b7d6a0052253f1a8ef5110e8b5a3bfede48584491"
    sha256 x86_64_linux:  "a2752b748e6b4496bfd7d0107955ea833d96ba14d6560e29e78e91dc544117b1"
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