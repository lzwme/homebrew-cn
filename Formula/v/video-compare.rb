class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20240429.tar.gz"
  sha256 "28f0522efa728dd817e116346211c40d744d66b530c57900855e5f0e2152d79e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bb869be045401f8e11e93a75d3c0e28c80bb2b9aec2a38bfe5e7ec6a7d60175"
    sha256 cellar: :any,                 arm64_ventura:  "bf1198b6d0f71cb5b64e021f73d18703d6f0c89378bc2a58b88a3100ecc28a89"
    sha256 cellar: :any,                 arm64_monterey: "4aff0fa3dae6ba37f26433fa21fdc29d698623cc29d03303f3dace7cd72b556c"
    sha256 cellar: :any,                 sonoma:         "129559add857557aaba28bca10bc7714e42f287b52aa5180cb767af2f1ed0a04"
    sha256 cellar: :any,                 ventura:        "641c1fc163d2ccfd30375be77ab6f236278dd6a38ad97ac226fa5d9fabdf8eaf"
    sha256 cellar: :any,                 monterey:       "c7c8bb776ecbf7f7d0a06816186b4e7c6b59d600ce7db365d7f79dc07ae12771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0eb29c315701ca56bb658dc14ba7f7ab204503ceb583ae4016ae6e88383b4b6"
  end

  depends_on "ffmpeg@6"
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