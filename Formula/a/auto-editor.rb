class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.4.2.tar.gz"
  sha256 "c12b00ad1fcad4d62bdc863c41c42a245410f8c74e3bdd6d1b5d4916786e3ce0"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9cc4ef6b08b544c85d1d841eefffebeb19b196b9646cd6f0c589cdc1250e4a5c"
    sha256 cellar: :any, arm64_sequoia: "d3dd782a55ab1985d5d56f06c6db687f556ebec0b090b8a996f1689ec2c19a97"
    sha256 cellar: :any, arm64_sonoma:  "7656866f767bb6854d42ecaad3f50554dcb8880570830798838a71cc21ad90d3"
    sha256 cellar: :any, sonoma:        "81910a4e962a845c9c58cc3f373053b4a576e860507b24406c515393e4ab0c6c"
    sha256 cellar: :any, arm64_linux:   "0a116896f1ffd05b87bc3ae364bd170776c1ba5b7f4b1a94e9a1d661cc87b407"
    sha256 cellar: :any, x86_64_linux:  "1c02435cd16a14084abf7b3850c31559c94fd992f67eb5846a43d53fe37bc1db"
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