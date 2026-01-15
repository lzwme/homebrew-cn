class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.0.tar.gz"
  sha256 "fa212ea93f114b7dfe8b196b9c68055e8123cdeda296560500b9ad384e120dee"
  license "Unlicense"
  revision 1
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2bc77e6b6501d1670f0db5742a5dda0ac98925ed3d5864a282d714973c548d2"
    sha256 cellar: :any,                 arm64_sequoia: "c77979b8af8f589502347a4e4b8caeb52481d9d71c955e59eae873a25b7737e5"
    sha256 cellar: :any,                 arm64_sonoma:  "fa8121a4dae02510d2fa54fc4c82b965d08214d2920587836f03b52d0c8e045c"
    sha256 cellar: :any,                 sonoma:        "e3f265404512297aacd9f1509a2229d8e1dd02e495c8736f7d10f32b37fc9fd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a8cd059a692372f9720be2d41223b28f4df3b4ff188e9a91cce3aa7a17962a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85dcaad190cc9651ccd682545bd11b1fd75830ea3de1fd57591b6613bf2539f"
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
    system "nimble", "make"
    generate_completions_from_executable("nimble", "zshcomplete", "--silent", shells: [:zsh])
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