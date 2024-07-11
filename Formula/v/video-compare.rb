class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20240710.tar.gz"
  sha256 "0e4edb537cc74d5b862994523b28fdd4d6b54c0bea94beaff64f26cf99fa4a77"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1756a8b5c3645016cbdc7640c47fcea362ca11f2e498bac2238e42fa58445331"
    sha256 cellar: :any,                 arm64_ventura:  "6a189524ba9f7df340e977c582e4c9c350270d442dd54115d150e6ee02b9f893"
    sha256 cellar: :any,                 arm64_monterey: "0acf4e69880aebfa4aa67e9fb5520b9baad2e2938c322836f99dbefba3de0d18"
    sha256 cellar: :any,                 sonoma:         "c17fafb8f37d36a9d83dc740df68c360064d5ba4f6a6c82ac926c720681c79c5"
    sha256 cellar: :any,                 ventura:        "ede5e082275348dfc5f88fc565f7d7626893d8b88153113b6ce4b9ad3179d6ca"
    sha256 cellar: :any,                 monterey:       "58dcab52dc89484d0a60d7feb48f96476dda9787c3752036040a24c8fe844d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f704307a8e37dba78666eec85837fcabc7c835060a450712a2f5d9c3660229b"
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