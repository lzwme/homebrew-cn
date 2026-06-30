class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "32c8d47edc102b60b148001ed2ba3d09313a523a4bdb89241dcb5c4211bcc08b"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "b39c57054dc1af8f743fae6b52cd4f99a3fbf08c4b1c2239cabe2c9e1e4f3be0"
    sha256 arm64_sequoia: "7e1dd0054bc8f10bbecee90c4f85fd79c5083ce809b4ddeb72666af18345d678"
    sha256 arm64_sonoma:  "06e2aea8e45ac63dbd74432f3b42bb8308977ef7d6c7d494e43d8be6faea6d65"
    sha256 sonoma:        "d9f0d503820fb5b50d084e8f78e0ef8e1d2bbfd7fbbe1607bf491898fadce989"
    sha256 arm64_linux:   "92204f0127ab77ec681d395fa6f3e0f87cf907a39769c94af5a56108f7897860"
    sha256 x86_64_linux:  "f63fc6bf72f01799c1732a6ca789a82e3e42c383af88312c907c67153909f8b0"
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