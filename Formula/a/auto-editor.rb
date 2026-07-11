class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.2.0.tar.gz"
  sha256 "7e08462a82300256799b57f296cff1a0bb9ec4ebdf50de6e7a35b2fdac318ec5"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b859570b3fd9ca27344fd817477a65496a6cb53ac5904a7d1f4f0407c1baa5f"
    sha256 cellar: :any, arm64_sequoia: "3311a1a6e0df5765ea1e3a577fa712928bad4159f9f23702f22c63e635569552"
    sha256 cellar: :any, arm64_sonoma:  "7ecb04beede5bef14153e3a7abd86309b089ff97cb17ad70423f8e13f48cec69"
    sha256 cellar: :any, sonoma:        "7e3a35b4a928aebae5c6027444397468138fa9b7e6d5ddb457ba58802a4c5c3b"
    sha256 cellar: :any, arm64_linux:   "24c8750c56a6ece8da10f22e21b19c4225c704cb09dd39cea7c4962545e0cbca"
    sha256 cellar: :any, x86_64_linux:  "97a9ebb476383089530141c19ddfa04381e7f99459e65aa08d3c86dc9138ae83"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "whisper-cpp"

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

    whisper = Formula["whisper-cpp"]
    system bin/"auto-editor", "whisper", whisper.pkgshare/"jfk.wav",
      whisper.pkgshare/"for-tests-ggml-tiny.bin"
  end
end