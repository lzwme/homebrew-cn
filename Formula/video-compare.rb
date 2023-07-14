class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20230713.tar.gz"
  sha256 "67c50673ae5870389b21bc6dda44156ceb00d09e76c821ef229cd220721425c3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87d0ce656b0136787683ffce7e48beef9e53dca5426320aecf1965265a8163ce"
    sha256 cellar: :any,                 arm64_monterey: "f3b1f3eff486e1461fe2ee4df376633520659551fcfdd965893e1686146bb2d5"
    sha256 cellar: :any,                 arm64_big_sur:  "7b120527b78c60997c789f00e7063c627dba2ea9716e9d96a538fb96d94a0190"
    sha256 cellar: :any,                 ventura:        "ec8bb3ca9826d673f4c30d09682b0196622edf3e0468893dcda7355cbe4998aa"
    sha256 cellar: :any,                 monterey:       "e6024c17e56406b53bf55a1c8ab4d5f620872c21834bc98e63aa0f9fe67698c8"
    sha256 cellar: :any,                 big_sur:        "fe899f99e4a810fb1bd90679722e61f3dc30c0b6cd8b6278b288f40fb1f61264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf670d6b12bc4bc705ed78d7950f26d7a4e1ab93a1e3b2f355653f211cdbdeff"
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
      pid = fork do
        exec "#{bin}/video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end