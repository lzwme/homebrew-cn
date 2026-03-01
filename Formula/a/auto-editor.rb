class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.8.1.tar.gz"
  sha256 "88daf3bbb52fb7f4818e56b52d86b3e4690bf87320875426d0acf068c7e6151e"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "032aabbf6e27fd086013ac6c0d0b42adf4490a70ea1e203f3165e13611710925"
    sha256 cellar: :any,                 arm64_sequoia: "0fb1af744497233d520486ed30759d770bf000cb74089079a51aed89e48191f1"
    sha256 cellar: :any,                 arm64_sonoma:  "091fc43f1efeae0d0f0c0d3dbae846316347849c634ba92f541521237e2d5c60"
    sha256 cellar: :any,                 sonoma:        "5bbe46232fc51431524dad28e90d100a27b17b68a5c065658f91c9ebbd19f7ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99862bbf08c9f533c3ebf494d22535fa03f6ab33b89a0140c2edc6c1c47415ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa37e5a16cedad636279a1af680f28ac0b753da85d1e088e09fcc1553f09531e"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "x264"
  depends_on "x265"

  def install
    ENV["DISABLE_VPL"] = "1"
    ENV["DISABLE_WHISPER"] = "1"
    system "nimble", "make"
    bin.install "auto-editor"
    generate_completions_from_executable(bin/"auto-editor", "completion", "-s", shells: [:zsh])
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end