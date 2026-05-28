class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.3.0.tar.gz"
  sha256 "0db9dc6a8d1ba1c1289cc37023e9638f3b43a9b927e35e918af0bf91364f50c6"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ee2840ea9052ca4ecc5cec7760ffc0c04672546e53a3d1faa58866751070efb"
    sha256 cellar: :any,                 arm64_sequoia: "4693854baefa50dd3974d7fe55e2efb7c596f0e33d9c53c15bfadc56aa2ebd85"
    sha256 cellar: :any,                 arm64_sonoma:  "e21f31189fb45769fd93e79f155a41cfcf248f3fbbd184e8cdb211aecdbbdeb7"
    sha256 cellar: :any,                 sonoma:        "342f9f9e8898ac58f5b1c7560c338f0aee7e8e461320847609bfc2ae287255c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b63521f08992edfb65897e1c7ab2f8564b46222b0f8336bb58275b653cbf7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f3c3d20cb2a1ab6e9e5f8d8d9ffb7385809ee4d5a59303a877286c2487714e"
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