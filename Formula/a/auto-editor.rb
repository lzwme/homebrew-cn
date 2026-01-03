class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.6.0.tar.gz"
  sha256 "fa212ea93f114b7dfe8b196b9c68055e8123cdeda296560500b9ad384e120dee"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "922bbbb4afbaf20024bea5e1e802c0061d8a738994af91c77a5309adc2738c91"
    sha256 cellar: :any,                 arm64_sequoia: "1f608cf9a7a8acc0deee5ab20d47553dbaa39ec27b2f1c52d067d6f246f4a8dd"
    sha256 cellar: :any,                 arm64_sonoma:  "018bdf94f36f7a86f5018c42e9d0218eb7b9886cb7d8748d9ddd16df41db3565"
    sha256 cellar: :any,                 sonoma:        "2b16e9cb14298ad68b7f8fa62a7ee67f724ad5b88685a37b8d29f0a75fd4d1aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eda0ec1aa9d65552ea5411386de5963c94b77488f61773bd52fd7ae612bc659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da7dcfae54094b6244bcb185e64cad0a39169df2337fe65e528fc733c3728d3"
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