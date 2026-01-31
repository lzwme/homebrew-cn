class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.2.tar.gz"
  sha256 "71144d2deb1796ba289853507d15e74a45099d250d606eba2d6d8e3aaf3ed6a1"
  license "Unlicense"
  revision 2
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ec3fe063fa9e1f2cceca539aec5d9bd949ccbef31ba34b7700cf7936098746d"
    sha256 cellar: :any,                 arm64_sequoia: "5c667b75e32c5d3c46ef78d76b478f4e0b06d07572a91f807d3d99492913b3a4"
    sha256 cellar: :any,                 arm64_sonoma:  "82f9cb5b9ce558e6bc819203d398e708c7e55e10670653b4b49bfdeb0fcab357"
    sha256 cellar: :any,                 sonoma:        "7278935edc4f846fc52e7dfb3b89c49be096b5638fe5793ba13369fc759cb6c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b4f48eebd729fa759c10546f89e411d003db17423513961832164f0696c156b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347fb0de9990947b847a9a023a21f0369594df7a3072eecae2edcee038e63a0f"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "llama.cpp"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "whisper-cpp"
  depends_on "x264"
  depends_on "x265"

  def install
    ENV["DISABLE_VPL"] = "1"
    system "nimble", "make"
    generate_completions_from_executable("nimble", "zshcomplete", "--silent", shells: [:zsh])
    bin.install "auto-editor"
  end

  test do
    ENV.prepend_path "PATH", Formula["ffmpeg-full"].bin
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end