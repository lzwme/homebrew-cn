class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.5.0.tar.gz"
  sha256 "f197fc184b4c5284d0d8283911d3e356fea47d9be1551080652e1400c630672d"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ceaae983fae4a2853cc3f436226fd2ad3e0cdbc7ec64286a1973f08ff413bc3d"
    sha256 cellar: :any, arm64_sequoia: "cad1347f9b5bbc6555f2dd26049dc4d54fc8f94f22b6518cd727fd96eb4b8174"
    sha256 cellar: :any, arm64_sonoma:  "37ebde9e8d768c007e85887d9d73f173d1bc3379f425aa531527c77cb21fc2a8"
    sha256 cellar: :any, sonoma:        "9dfe7c39049f6e63cad79f667eefe52bcd7f52dddef369bd062f17a653878fae"
    sha256 cellar: :any, arm64_linux:   "c7f1a690d30a72d797703b2a2f7024571f8190b781b7d9a49533d39edfd25336"
    sha256 cellar: :any, x86_64_linux:  "12586b253d257567e8932efa342beeaa8b8a63f284a5432f9b35f86e548df765"
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