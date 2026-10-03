class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.7.0.tar.gz"
  sha256 "03acd0a3d7642138506ad7a49627ca7e2ebd8ea9aea4455ed509a65a1ccb2afe"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3ededfba7be7b8c8822d251da26862186a4831921c6e17570f2822fe09a8ea95"
    sha256 cellar: :any, arm64_tahoe:       "a62dcf0e399f37b73e6286c57733ce64af36f43e2d637f069ae0d95c0876a42b"
    sha256 cellar: :any, arm64_sequoia:     "64c275f86704ac465d9346b5a2f9a43059317cad170ac0f5b7332ee8c5771572"
    sha256 cellar: :any, arm64_linux:       "74510e39ada95ef20c6fc6d2f5ce0e3121b60b53b40b11d2fb1b0ee5a64a0224"
    sha256 cellar: :any, x86_64_linux:      "5c6bf11e6301f48b8973a785d976110db0ceac130c831a5cbc5e6b7414edb59e"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "whisper.cpp"

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

    whisper = Formula["whisper.cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end