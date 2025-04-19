class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https:github.compixopvideo-compare"
  url "https:github.compixopvideo-comparearchiverefstags20250418.tar.gz"
  sha256 "dc2ac8d8769c0e244b3472130246c03b5316815940de1c9943664c448c0c666b"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f4d0f9760f78c686363f52dbed3e034508b6fb9422482058c36a52eff21ffc1"
    sha256 cellar: :any,                 arm64_sonoma:  "e86e5bc45fdb9e86a8ad9d0b4eb0203effa60e92f704cbee09ae41d683b4c7b0"
    sha256 cellar: :any,                 arm64_ventura: "541643176a1a234683ffbd35cb77c840476b61988f26f7bc64ac88af9d245f96"
    sha256 cellar: :any,                 sonoma:        "a9ac623ae19291d53e1060d371befbfea3407455fb469bdea258ce9c07967e4c"
    sha256 cellar: :any,                 ventura:       "9dac0c48e30ecadb15d0effa5bb84b5f3c2b4e21000dd894198555eabc6d3e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ea74e707de457ba3d8c204b25b7b85be20ec978b18014375809fe63f83d7d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db38e3ceb13bec7e477f22cd3a0c5cd380a14a59a1826db9ee23e4d192232b9"
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