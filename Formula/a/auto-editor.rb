class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.7.2.tar.gz"
  sha256 "8dd70c1f56b2533995249f2029ba807e9f630355514994aca8ca65ba88bebf89"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cd59ef8c9383028eede01e70ec91631bc595af14dcaf9740d2241ed33c58fc8d"
    sha256 cellar: :any, arm64_tahoe:       "b9c89e478370d641f565de30e821ac736e9bf805fb28309e5cfa9757d4e4da2f"
    sha256 cellar: :any, arm64_sequoia:     "124ef1cef43eeb77fb0c1f1bff5b595cf017706d6026361469cb018bd2abdd7a"
    sha256 cellar: :any, arm64_linux:       "eec79191616a5bb9cc1725440e25aed089670ff443c4cf5411ad2426d5e50330"
    sha256 cellar: :any, x86_64_linux:      "bcac8c82f66b8c8247cfde44f96afe1f278dd05f533185928762adc4faba4a19"
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