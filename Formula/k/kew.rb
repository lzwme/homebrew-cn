class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.3.6.tar.gz"
  sha256 "e5986086d508f3c5a4d9d4ad983ec0f95afbc0dfd0797aacb68e731f1102f0df"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "63244c68bfcf3c8d63bebdef35d2e841e0b96a065a8fd2adea783c281f4f6491"
    sha256 arm64_tahoe:       "4c5d91eddf8519f868c4f6c3b17044d40935489fd7e6f0fc62e47d24f01f26d1"
    sha256 arm64_sequoia:     "68a7bba92de71f1117c4d00c0669a64245982cbb4c6bcea461208c2de0524f77"
    sha256 arm64_linux:       "1f9efc0976b163454e03ac2eb87ca230404cff77246ffb05c21d5247ebe2f140"
    sha256 x86_64_linux:      "246db87beba715af96d889b049102c42b07be63d260e6c408b4e3a165640a7e5"
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