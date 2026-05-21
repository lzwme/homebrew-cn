class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.2.4.tar.gz"
  sha256 "2d26dc2808fca05bee2dedb875ec4e8b57279d907c212255450cd86c705374c6"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2742ef4769b4547e2b842ceae51ae05e440908fd3e61d4af5d32d62cc286749"
    sha256 cellar: :any,                 arm64_sequoia: "3fac117a5feae8c0cb788ed6bc76903d7a877e6cf29c090cedc5165860e15010"
    sha256 cellar: :any,                 arm64_sonoma:  "654fdde2e7ab69f118a3d2ebb4978b3919002af198ae3d8792d2184be93df575"
    sha256 cellar: :any,                 sonoma:        "e0f51cca6a7a129d9c641cc4cbec73f96b2051fc51443dcbb941efe0561705af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc3fe120240735b3414b623c4e29e6dfc23284c5f1a8fc4740ba110e30264e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2f31565df869fcf37cf751327c7f4542ea22de6ead2589585d9729bfa9746c"
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