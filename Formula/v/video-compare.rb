class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://ghfast.top/https://github.com/pixop/video-compare/archive/refs/tags/20260121.tar.gz"
  sha256 "32c86e98fbcfb54a8bbbd9b47bcee016350958845fd8f5aebb62b73da3bec4ce"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eeafb5dd900172d801da9d734de479970fb6391982657616b84577539569120b"
    sha256 cellar: :any,                 arm64_sequoia: "d461c229409833abc722d5af6c07d4bbc36f9007e6108800f1438147fbad9f5b"
    sha256 cellar: :any,                 arm64_sonoma:  "e255d256f2c6dcbd879443beb6d16d12cdc080caeae66b846aeffb82a8d7f703"
    sha256 cellar: :any,                 sonoma:        "81f6e64caf988858a28ee907a0be2fce1e6a79a5f168e1926b1c6e36d6517d86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e68bcf5ee0b2a50682f6305490a633d8655be5ec761571aee30e4ff88f6be99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595e426e9cb41d7410bec47bb7a3deb8aa44598c850caef59d55904674d3d520"
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
      pid = spawn bin/"video-compare", testvideo, testvideo
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end