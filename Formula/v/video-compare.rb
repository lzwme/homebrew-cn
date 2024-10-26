class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20241025.tar.gz"
  sha256 "95a14ae51f714f72ff3c863f8045ad16ffc5294adad9537083421f37938e395d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ba7e9478c19ad39a26da60ba902d350a7ef849c005a6ccba1fe1701e4b02dbe"
    sha256 cellar: :any,                 arm64_sonoma:  "a00b35a2210acbce7f6c5927bfd4ffbd92eeb2f097e5951eea23411f50d57a5d"
    sha256 cellar: :any,                 arm64_ventura: "2d274294ee9842f7d85c3ddcc3874fc308741e14d7967d5d5bc41641bf25b8e4"
    sha256 cellar: :any,                 sonoma:        "eb0155b5af9e11388d726fbbe4a10ef1ce96f764d1610e6cfef71f66a7c23164"
    sha256 cellar: :any,                 ventura:       "d9e1293e19acfed4a2f4d0fc025d5e3e9f2e1acd58cacaec0be9353e659b8fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923ad632e895c63dc533ef01c55b6fa3c793289dedd328dd351ae930f44e8525"
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