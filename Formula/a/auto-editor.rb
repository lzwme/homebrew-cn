class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.4.0.tar.gz"
  sha256 "eb1f6e56543998acfa9a17b350d058e03df5138764959da88df5139dd589c87a"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "91f7db437f7cf5c1d36ef8988b9b6f2842031038f5788aab365a8cd78cf67d77"
    sha256 cellar: :any, arm64_sequoia: "7308be5176db1dd328c944ad5a620c4f41ee66740ff038e3576bc40848e763ee"
    sha256 cellar: :any, arm64_sonoma:  "614348985a2d60e5dab1c70cde4d12ef9ecd3310f095ff84992254c8b891df60"
    sha256 cellar: :any, sonoma:        "f77e436457fd16eeff26a789cf5a006a057140179e414205f6f55dfd98904670"
    sha256 cellar: :any, arm64_linux:   "0050d87e2755ba8e0eaa1f4c374806da6bcbbe2245b6d8a5b6292ae21f431f23"
    sha256 cellar: :any, x86_64_linux:  "4d14ebfca56bc709545a6dac0ce1577499721d723d1db0a6117c933c8059a1b5"
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