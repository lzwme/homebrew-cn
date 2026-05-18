class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.2.2.tar.gz"
  sha256 "f972a6a38ff729953d4d2f6b487ae04684a26a1c985524696d4218dedff119df"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7982382f6b001a45af0315e0de433c9e5630c524027482fac84e7c41d8c53a39"
    sha256 cellar: :any,                 arm64_sequoia: "c669965b6e59215777a6fc88b9f6aea914e45608446f9bda957064b096d95075"
    sha256 cellar: :any,                 arm64_sonoma:  "e91635e04a95d48e58fd1f0ca7fef6aca82b69bb18d689f8d188953a8d66f1be"
    sha256 cellar: :any,                 sonoma:        "67169a289e8dd8e3aa838fdb15976a8ca89c309f6c2e6b48ba2c047b74550f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3a721d5702ce4e451bbe86f7a37857d4f1276275a10a6a698a369cc6489da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da02c8dc6000c2dff364451fce65a9e325d36627dd20db0dfc934210c903ee5b"
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