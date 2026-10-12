class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "1b3b66f5003a272ac33f38415968b625f4dd0a6a9eb1417c14c739b580ad62bb"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "ccba8c29be36c2c09c3c0785accfbc6a136a7fff9b8c6dd793deb8106923dd44"
    sha256 arm64_tahoe:       "72442d5121f861425d6e5bc1c9a3b923dae83a379670eac936626ec0ed61839d"
    sha256 arm64_sequoia:     "80d427ede711c492dfeb11c9c65fc616e9b7451c7a928a173d5e29ce465f74a2"
    sha256 arm64_linux:       "6d5955eb9fe19110501223631a630750330dcea4f588bb6f3ff193c51a35dd34"
    sha256 x86_64_linux:      "911ae37be85c85e44982e570924ffa8a3129fa24d3b8a013c9547ca761ef0be0"
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