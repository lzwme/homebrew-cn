class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20231223.tar.gz"
  sha256 "3c3f79c19fce40738a01cab3f70a7ddb9361d60265701c675a9e73d141a2988a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "503c8847e9a806a89c97bc661ce1dcb0d7c5956ba3961276a224b3ceda916a70"
    sha256 cellar: :any,                 arm64_ventura:  "8ccc742394d30d448c0f737ac427ed2c63b940e2db21368f32b6f52e00ceac13"
    sha256 cellar: :any,                 arm64_monterey: "56a2a535bed345585e23f6e08ea4098756d3c3be7a87bb672bad3feb1853bc79"
    sha256 cellar: :any,                 sonoma:         "fbff38c7ac3860f2a18e2feea29d43f51aca69efb497068b40f4aa53a01a05c8"
    sha256 cellar: :any,                 ventura:        "20bec7d276a5c9b631a5f006bd1c7344f29c09eaa996c08a60d1c2b3d7c76b2a"
    sha256 cellar: :any,                 monterey:       "9c952b03ed0c77dab198938ac60dc2317f848e0a5b2d66d6ecd53c89dc47faf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda0340781de110f2342a006c5a5c209b4742b564adcda20bf6a0bd34a2c4a47"
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