class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.4.0.tar.gz"
  sha256 "f40a636c46d29b185704808ab5a730ce272856ad176438bb7782595992009acd"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84a011edd0b1460647bdbe93de5f4d06ed189f2dcc77517ef10c49ca720390da"
    sha256 cellar: :any,                 arm64_sequoia: "a66ba6a84b0f7940154d31b90a29f818bec2ef7384448d1db84be34a7c54d7c5"
    sha256 cellar: :any,                 arm64_sonoma:  "97bd8fcb8ba4ca47c443fa31f0325d18394a9cc1ab31f33d99ec0317e1df1671"
    sha256 cellar: :any,                 sonoma:        "eca852b311472ef9c375c1dd754c174718da22ec4341d0e4a80125d3b31d0a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f025e205852a143c18b4029db7cabddbf6f0e444f78d1d64daf90e86eba0e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79eac5f0d297aaca2e13af274fd54e37ff9998bc6066aaf26cfab0f46187abc2"
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

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    # Install Nim dependencies
    system "nimble", "install", "-y"

    # Build auto-editor
    system "nimble", "make"
    bin.install "auto-editor"
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end