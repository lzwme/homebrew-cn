class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20231209.tar.gz"
  sha256 "58ec6ef8f7a20b01c06aa7bd2793a01d8066b415d53c8e555f15577d5ea44250"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36151fdb9fc93128b1dc647c776afeb71fef227d55a3525b497b496fe5735b1f"
    sha256 cellar: :any,                 arm64_ventura:  "6a05b8726ed9d897f366ae4e372583bbbc36370615f554253d75071453544464"
    sha256 cellar: :any,                 arm64_monterey: "9ba53c3961dcb6b7fd9f1555451f20348c44065acc73260a6e0eeaabb34d3d99"
    sha256 cellar: :any,                 sonoma:         "31350a3ea4195869e8b9407850c01e095478f458a7ca0c80ee14da736978a2d7"
    sha256 cellar: :any,                 ventura:        "c578addf38f799f9e451b47daef1b302471b19596e445774a9595389ab85602f"
    sha256 cellar: :any,                 monterey:       "ae9a33fb2fff1cabad1744dace492fa1a39cf833f3b6d0334e7c8cf22cbc20d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efcaa8b0ea974ac0974daeefe28a7339cf0c63414841bd7a281405b636fb48d2"
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