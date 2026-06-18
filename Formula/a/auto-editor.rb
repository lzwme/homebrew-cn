class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.0.0.tar.gz"
  sha256 "c182eb7e634e7b1b1e016b4ab82431f74b19a3af9c91d1216067bdaaa4a7c429"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cbfd4ec21a6c3f874d5e841988fec60b27a44bfe38c017858862b628b74e198d"
    sha256 cellar: :any, arm64_sequoia: "6528c0369d42da538a1134b0d83718c7d0ce1d2f2e97e14f05975fc6d0751cb0"
    sha256 cellar: :any, arm64_sonoma:  "b01963e5f882ef13f6e6a10dbbe19e95ff5f03fd3a37403bec4f543724f43207"
    sha256 cellar: :any, sonoma:        "4bfb26a47bb43ba38980e781e02475957a41efa4b42760b97483dfb398a4480f"
    sha256 cellar: :any, arm64_linux:   "845f51302654feb86db47ef933542198bd3a2f538909a6e1599fedaf4271e738"
    sha256 cellar: :any, x86_64_linux:  "daca76c54a5db10e8d477557538defd8a7b63539f1b5933f44a0215634b815ba"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  def install
    system "nimble", "brewmake"
    bin.install "auto-editor"
    generate_completions_from_executable(bin/"auto-editor", "completion", "-s", shells: [:zsh])
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end