class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20240623.tar.gz"
  sha256 "1d33d8e2f43b26d6df3f72a61c285b9640b92cb87b1538012f5019bc2e284994"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "907e166c0c08b11635eacb3880d6d81e4d8c2df99205b4e532bf4a46192efc19"
    sha256 cellar: :any,                 arm64_ventura:  "d07ec437352825963309b4046ba8e1f8527b18e1d8048983eb1310d55e3141af"
    sha256 cellar: :any,                 arm64_monterey: "21a6c26faecd41c75c089ba3ba0dadc6e99d3fa96bc47b5b8e219953ada78285"
    sha256 cellar: :any,                 sonoma:         "43e6d469a58581fe6abdaa285440a25cdfd4f9fda322aef6deb780bd197a976d"
    sha256 cellar: :any,                 ventura:        "8c6d97aeaa3e066aaea8f1cc54641ec484d6a32f7305c83c8822f30800e7a978"
    sha256 cellar: :any,                 monterey:       "71ad24b289d040dcad79e75643c7cdddc6ab62263adc82ebffa1dc56726e832b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c44f78d7c9879cbae26d470c1589c52f5bcb266e881d9e450e2bdeb26a61d6"
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
        exec "#{bin}video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end