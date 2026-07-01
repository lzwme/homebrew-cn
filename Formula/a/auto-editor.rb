class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.1.0.tar.gz"
  sha256 "39657c3e6990afc9fe668b0b7f5f482da19b73ed10f877025fe7438dc71fe734"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44d64109a7bdeec76cc162a6ab6520aa6a6d07025aa92243a6ac55269ca7245e"
    sha256 cellar: :any, arm64_sequoia: "49050e79987c7513f3792bdf222fd8776a22283400a1938a72c126be63d5d28e"
    sha256 cellar: :any, arm64_sonoma:  "83d17017f8deb8a55a6c02ccce36930e8007ba73afc001fcc25fcf6ecf09be87"
    sha256 cellar: :any, sonoma:        "53ebae9dcf05c3e19eab8b558941ab109eeffcd54ccc9211d87dd78039304aee"
    sha256 cellar: :any, arm64_linux:   "46b8608c0170197a6c1740dcbc8b0a7b0f31c2f93c907627f7be6f50d80a80ac"
    sha256 cellar: :any, x86_64_linux:  "71b3433f240c2d838e17dd51ebbd3e11912065a8bca58384463452e6fea53a1f"
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