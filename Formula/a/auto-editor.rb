class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.6.0.tar.gz"
  sha256 "9cea80d4c58bd454dc760e587cd73a419bd997cdcdfffc84382ea95dd8d72902"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "72a307562d842c78857394430c6464734a87a98e65526d2d2f69aaf3f1201a1a"
    sha256 cellar: :any, arm64_sequoia: "39d927f1da75a75b2ec6b21168db38a28d15bc8692d02fc5a971b96cd0fd458f"
    sha256 cellar: :any, arm64_sonoma:  "045a47e4290b5c9598006ee8ead965f9f6b3dca716192afb26a275c5058197dc"
    sha256 cellar: :any, arm64_linux:   "534c56571ab73fd91e1865512fa9c4bb02fbd88cd0425f1c8114e5d6fbcca9ce"
    sha256 cellar: :any, x86_64_linux:  "d9b6e2d78c389c73bb7b6d4b863c6529962d5929866efbecad44ccd645be9e4b"
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