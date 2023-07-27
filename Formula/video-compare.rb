class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20230725.tar.gz"
  sha256 "90df85be00be08dfd4774bc24e657cc6133531d9fa8b46538e716a3a58bf260d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f81131a1da76f5378de1a498b9636e2eff00ee91b2b029567924503cf23d447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a5e0bfd78f1f2bd11c24cc5f125c3e06fe14d731b26f4f7a434feab5ee8573f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7292644bfa3359ba95160479aaff3cfb9964e28f8383ce8c2657180305850212"
    sha256 cellar: :any_skip_relocation, ventura:        "af1e838400008cbde45e2ac2a22758fa64c78eb21f65096e2393e20a0a643100"
    sha256 cellar: :any_skip_relocation, monterey:       "0896aa5064ac21c77c14396f3872ff7dc0efa6501afc5f21015cd517acf0c225"
    sha256 cellar: :any_skip_relocation, big_sur:        "4521918b580488e478f7a7dfbcf1e56c23fdb3197b07452d86ccc57dacb218d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cfa992ff244efda8e8a54a8fb4a7f7bcf3c089af298b3fbb8578220cafd6199"
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