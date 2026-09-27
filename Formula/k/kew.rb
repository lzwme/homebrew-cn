class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.3.8.tar.gz"
  sha256 "8bcef75765f89ae45622e918bd4476f6cdbe1857cbc3fdaf5e87c6dc56de180b"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "3168dab1982530811faff876ff4a763548f10ac9248f1d2a684ee5f374ff7dfb"
    sha256 arm64_tahoe:       "9ef394694c7e624f2bddb777c1b16884643e1666530982b3859900e7a3b9d8e8"
    sha256 arm64_sequoia:     "2fce44ed6ade1195fd0a557666503465cc199fb0830ab22369f1d4d150a6119f"
    sha256 arm64_linux:       "686545bea3b21f1a67c1b07608d7a3971e5f4bfb1a230c968a48b86c6f24c833"
    sha256 x86_64_linux:      "2d8e6c093e8b5238ed041834c351daa99e9a427a0ad988a8a6c88a8076c82727"
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

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"

    (testpath/".config/kew").mkpath
    (testpath/".local/state").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    # `kew` puts the terminal in raw mode, so it needs to own a PTY to avoid `SIGTTOU`
    output = ""
    PTY.spawn(bin/"kew", "song") do |r, _w, _pid|
      r.winsize = [40, 120]
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "No Music found.", output
    assert_match "Please make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end