class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20240107.tar.gz"
  sha256 "977f3945642c9874f6b5ae30589f61411819db1f2ad7b600758bb8dfbb1b29a9"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36ea856d82ead7671a50e6c11df1f40189d2a85409412c1f45cb25f91fe9192c"
    sha256 cellar: :any,                 arm64_ventura:  "1e0d1cd52f5d62b2201e3d0fc01fd0de2bbbc92162ce16efe08d45b04abf12f3"
    sha256 cellar: :any,                 arm64_monterey: "46094edec2973449cc88cc121ceeb05b94299362c546d0d10d20dfe0dfacfed2"
    sha256 cellar: :any,                 sonoma:         "502a3476d04c56702e155b343d1de04a5f43057a111f977cffd9657a71e50fe7"
    sha256 cellar: :any,                 ventura:        "f663e3878c0f09b359f77b9b720b72722395dc6c9250d2de5dee026bb318ba31"
    sha256 cellar: :any,                 monterey:       "b961a32efd96aaba6b38a26e9d9073edb24b4205cbbb497c6495f675441a608b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb3e27b51636d2777e290efe364f903b1f6a5ee5614d01a2b2cd0fc05cc938b"
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