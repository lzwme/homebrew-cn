class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20230729.tar.gz"
  sha256 "b916d61561ab7efb3e06af5035c4e8d26566349294e27d6b122c3a182a075c5f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bd62e80318c47a69fba695cf80e83d0778c9c7a6026d37d3dd9127ae390003b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a44e252f79c7cc90f825372d67f256f9fce00797e8a3233d77946c20b5a2814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64122eb702f9d53038629e3d342275d1d3e0c53e195a20bc16e06b218e0596e1"
    sha256 cellar: :any_skip_relocation, ventura:        "e3f423dc84de62643bdba3e028afb0c4973a9a62f1cc3e3b914fcdcab1b04fc7"
    sha256 cellar: :any_skip_relocation, monterey:       "43b5b599340d64930bc9ac38e6a3dfc9d014b7e951da89b59b4b1070ea21fe60"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3b6afa71c3e21f74329028d72a1e9b653f370dfe628917e1b1f2a913c64d9a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ed6ded887b726298c9e5f534daa1c014a4ea16bef9d86d03092cab6a7261c4"
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