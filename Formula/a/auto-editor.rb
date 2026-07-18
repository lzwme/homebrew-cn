class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.3.0.tar.gz"
  sha256 "4fd25b59b1c93585da8bd9a296159f46fdde6f9e2d23d7c12fc27d7a4fc6e873"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5b54d21d75871a5c13db34ca4621fb98b9e01f334f27318963927e025ec2135"
    sha256 cellar: :any, arm64_sequoia: "af2d32a3521746f2c855596882442227e4a4a1ab1d4b6045596301a52175e29d"
    sha256 cellar: :any, arm64_sonoma:  "cefa7fd92133732d43923c13f05d2e6085aec9cbb77b00bfef28895fc9788d60"
    sha256 cellar: :any, sonoma:        "2d9f20e571b44abd6d1980ae5940f37b626bc8881f56160478955e3ce6e16259"
    sha256 cellar: :any, arm64_linux:   "49fb08ec543ccdb5e8a50ee6df6d51e4c0f72c4f58403d3785c04c30e988779c"
    sha256 cellar: :any, x86_64_linux:  "527d7ed4c0c2437635cd1a4020bdefbd52e64e5151216964b0a7af3f9d82559b"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "ggml"
  depends_on "whisper-cpp"

  # Link parakeet in the dynamic pkg-config build.
  patch do
    url "https://github.com/WyattBlue/auto-editor/commit/ab693319c6ad61a4af5ca744c99a275b482c4e54.patch?full_index=1"
    sha256 "968362c286e5e99493eaf466ee296107cba43ac3ca53a46dcbd700220ac7ee18"
    type :backport
    resolves "https://github.com/WyattBlue/auto-editor/pull/1284"
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