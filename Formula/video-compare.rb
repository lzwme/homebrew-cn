class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20230723.tar.gz"
  sha256 "c0962a9c0aae852bd664af28e66256fbe9c9280a8c37c37b144362f0156d33bf"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "befdf40dfeb543bc8374e3c945a5ca0d9919e558e94044ed34081826895c759f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de14c1b8eba3dda9a300851d59880d422e9a4b35857265c387601e0eb61a977a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0571d992e2cae8f9f09058f194081d6a16a9fe3f2e7f168e4a66afacaac0b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "86b68bdc21fa2c515d1eb2d15892c653d231b3877a61791575ed52a4fbeadd50"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ab7cc3c5ccc190e003ed9aadf84eeb71e03debb374afc112c97327366fadc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6544b72678bd53ab3ba6261d4fadbf0554db760c29b8ccaacbd0cb82756576a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "856794c28b2c24133ace6362a3079698f00bf8f3484e7bbdb5ae50ccd9bf236e"
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