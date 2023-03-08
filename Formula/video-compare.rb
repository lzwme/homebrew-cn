class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20230306.tar.gz"
  sha256 "8997538442baa5ac16d7d7d85bdc5e2b2be8668413c90fab69286407c683dce6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14efa20ea51cbba68749630da39e457974eec1c84cc15b865e65bece5b435654"
    sha256 cellar: :any,                 arm64_monterey: "b48267635d52335d2481eb9eecc36048b6934565373e565a401bf6d908b23af4"
    sha256 cellar: :any,                 arm64_big_sur:  "4646d6ed415099580e69f5f7937ea0bc02c42f81e9fa628a0b529ca2d555a7be"
    sha256 cellar: :any,                 ventura:        "2e74360abb406934dd8e7af0ab0c8104bc03b3bd355c98b2943dee54182d5096"
    sha256 cellar: :any,                 monterey:       "71b165a6b227c6b6a23e01ef24683ae696dd806df0aba54aabd3f97cdee10819"
    sha256 cellar: :any,                 big_sur:        "8bd70a7563583c48547124ece3b607bfdc9c8e8871d461e148285952a92e132f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d2fadcc0edbb8c8873e699b92ad89e531f116fda569d0e5eb9ff92ab4f0c0f"
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