class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghfast.top/https://github.com/pixop/video-compare/archive/refs/tags/20250824.tar.gz"
  sha256 "8c4fdabf104c4ded5adb62ba8a9821f82d05781ea13d813778e7ab6ef42188bb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54306f9a543dec649475ef8adf64a164226fc6e0f122d97dce2f26c7f636afd8"
    sha256 cellar: :any,                 arm64_sonoma:  "7ee4dbda90937fb2633f46d8ba0cc50fcdfeb646ff1c622b82fa9cc111b55c69"
    sha256 cellar: :any,                 arm64_ventura: "05eea29074fc0a17fcea33d6324b675020b634a38c455198f787e7afce429f23"
    sha256 cellar: :any,                 sonoma:        "e235278770764a2b966dd5e022420431b8171f5ec34056144af439f38fd91fd8"
    sha256 cellar: :any,                 ventura:       "39ca782fbfbe6a74092693cae71a8d3fa5340f09a8bf162b3d523eb75c584809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d3a72ba0a088ebcadcc351b3932a420e25673858e9b462d264e5f8fb0581505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7b6d3b44d8ed50aef5f77ca1b4ad4659893f3ec03f3d1fccae33337de7e057"
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
        exec bin/"video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end