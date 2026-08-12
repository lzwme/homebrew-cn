class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.4.2.tar.gz"
  sha256 "c12b00ad1fcad4d62bdc863c41c42a245410f8c74e3bdd6d1b5d4916786e3ce0"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c6a751397dd82efa263da9abb57f284baa025e5b3467823729554e4dde58994"
    sha256 cellar: :any, arm64_sequoia: "94fe5c97c08ea6045643d78c8025d00390c098bb00d89c32d8475a78f86e37f2"
    sha256 cellar: :any, arm64_sonoma:  "66ab4c1a3b81d3503ed63972bc87406228d2a31b8281bbfafbd44fd9e706c5af"
    sha256 cellar: :any, sonoma:        "ccded83b04898647854b7b02adc318cb23745699428db687e95baf8d17f621f5"
    sha256 cellar: :any, arm64_linux:   "1ec4f4526171d3bf9c1b89ec2e9e084d240b4a10389e9b3bff5a87674b53360c"
    sha256 cellar: :any, x86_64_linux:  "908ad07b9321fa99e478edd0afe11e31371a1e690b256e37801807000b09430a"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "whisper-cpp"

  # Fix builds with FFmpeg 9. Remove with the next release.
  patch do
    url "https://github.com/WyattBlue/auto-editor/commit/be5ca8116a7fd179837301e3fe1383fff6b24a2e.patch?full_index=1"
    sha256 "ab37864e4de76b711dc3867ecf7fcfb7abf9d6bad5bd2f4d800383c9013e28f2"
    type :backport
  end

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