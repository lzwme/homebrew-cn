class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.7.0.tar.gz"
  sha256 "0e400bebeb50745cb42396b93b4503272db6f7d72e85d5d6829d524fab8bb403"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac73be6d7635317f4797ad5ad6b0778a09995d4ba86497000553bc8a45e6a252"
    sha256 cellar: :any,                 arm64_sequoia: "25fa9c9ee27d1b0eb184f1e0fed1aa3ce322f4b341a528f53cc1bdd429556bce"
    sha256 cellar: :any,                 arm64_sonoma:  "01c0f683e39e36bf21a6f86f9ac5513562bf0a3a5dbdbaf2ab340e56d07c6c47"
    sha256 cellar: :any,                 sonoma:        "6384392f0798718e253d7d3d31cf2da8aae1d8a11ae9ceb3efe1b0e969cd2afa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddba70e650348bdea6a2cd12d303d58a5367ef0ac1b799aeb7d5fe8dea82b173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1cc066c7c1d05eda8c878d3749979bc6ff6fb7f219b188ad7a00a1e08de6104"
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