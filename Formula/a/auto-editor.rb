class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.8.0.tar.gz"
  sha256 "f6b982c70d1e018c9d6742bb4abcf16a1575cd6ea80fec109a3745d043ecb234"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5057d324c6811e0e9ba023d4830f8e85beb8fb78de6f56411d0fc445395be1a5"
    sha256 cellar: :any,                 arm64_sequoia: "b250ad0c4a593c0ff22d883105f8222251d9cbdc379450e8b8055c0e5a8c146b"
    sha256 cellar: :any,                 arm64_sonoma:  "b9ffee857e8498249630024f774c13fed7fb3df155c1f5d51d6d8cc595cc15b3"
    sha256 cellar: :any,                 sonoma:        "10bf517529de2a9d109f7254a63b1cb80e567bba631344db02f5734be492a936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95c8c322fa4645e1a26ef89d6e62c2114c58c99751829ee056b1ef0188e444a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6d080de69090aa6d1070be32fecfebe4e682137e3a106f5ec38f765ef2355a"
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