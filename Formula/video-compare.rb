class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20230709.tar.gz"
  sha256 "787b00225f46394171476dadfe5990c93e7022bc9306ee40e9ddad0e200a4c38"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c733b548f230949db05957cb32cb2cd45cb2b183dd8f9c441a89d75681bdae6"
    sha256 cellar: :any,                 arm64_monterey: "91aa6209c3b658fb92814b0ebd80c83c2c20ef811292d83aac30d92c852f761d"
    sha256 cellar: :any,                 arm64_big_sur:  "600ed68c74a7e9efae72c19fe04fc713a970056698c09c2d5705d830f01f7b70"
    sha256 cellar: :any,                 ventura:        "cbf9c9639171173ce7921c5169db6a2f1e586db480d1d56aef9c9dc24df885b7"
    sha256 cellar: :any,                 monterey:       "9ceadcab9b89d42ac5234477407c4457bb57e819fe46d7fae202ff94c5570b2c"
    sha256 cellar: :any,                 big_sur:        "3dfa3c61089ad7c2c18a8f27444b11543ded0f93480cdb240495e58eda5921bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5182e01c25661dc94929f5147e6271373a29d01721f7b2c23eb6bd3f87a91968"
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