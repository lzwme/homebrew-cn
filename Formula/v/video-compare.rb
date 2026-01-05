class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghfast.top/https://github.com/pixop/video-compare/archive/refs/tags/20251213.tar.gz"
  sha256 "4b79583a52494ac35b5edd216fcc985e591fd0456e06c474972b51606d220272"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3991ace6e26cb00a8ee7e4b79d97793d0b1e0ba3db6bb9f434d294038a7065e9"
    sha256 cellar: :any,                 arm64_sequoia: "4fc724c2c413c8ec2732cad1248b43516138aead62a028fad931552e533620cc"
    sha256 cellar: :any,                 arm64_sonoma:  "c64faa8c4f44caa51e4aa401ee727d3e795245e728c52848201eef7d6b1c3c8c"
    sha256 cellar: :any,                 sonoma:        "ababb955b17e08fc6e69e717d1623583fad18e14f961dff774e049c5d7781734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1205f01248bdc10aabfd25efc0cec6d2cc214a32a51e15c274e9f933ffac9c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6725716edf7755989a473439bffda47c6d44c5116540430b177fdf2ee1271d"
  end

  depends_on "ffmpeg"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = spawn bin/"video-compare", testvideo, testvideo
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end