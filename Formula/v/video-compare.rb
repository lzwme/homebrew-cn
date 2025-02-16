class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20250215.tar.gz"
  sha256 "8d63c6ae9a2d27c772205b4f9bf9a9b3d85685bd78ba322202ed41a380cba0eb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a5ed19005b7010247e820650a31c80d7192c1b8c1082ea20f2b317562da4115"
    sha256 cellar: :any,                 arm64_sonoma:  "8c1abd9bf9e0295ec7ad615d84fd34d7a19e811e81c184fd02235e859194adef"
    sha256 cellar: :any,                 arm64_ventura: "a4b536e8e826d33be54b43effcb4d9982edd755a9ee4701abb0a39f73e8da280"
    sha256 cellar: :any,                 sonoma:        "a5ba9c7308ad5d0a8df76624a375a397462b7c976b5f8b1cf8f2f2ef6231a142"
    sha256 cellar: :any,                 ventura:       "6d0ff966a92ffd466bfc4f7edaeced6f12b7e8d7f06918f707d7bc3a9ed42d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f784460c9cc5e5b17e57470e6d0d3515e5d82f70aa9ff7b8ecc1be1618bc04"
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
        exec bin"video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end