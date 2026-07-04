class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://ghfast.top/https://github.com/WyattBlue/auto-editor/archive/refs/tags/31.1.2.tar.gz"
  sha256 "155b594c15c4c0f6ccb822ae2c70089541fb7c516924610ef8fd9c8748416bd1"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be3873cf3d572a3098732636e3d40db1f11937bb6f7de1aca920e1c253aeb91f"
    sha256 cellar: :any, arm64_sequoia: "58482b8ed78e53fae96a1204edd4bf44105db68ac22415d7ba83b6c9968d84a7"
    sha256 cellar: :any, arm64_sonoma:  "2f8cda0cb62484bd0e21e2670d8266ff281e5fa7c27f1dd7272d47ae7d2ea794"
    sha256 cellar: :any, sonoma:        "addb9575ec43d8aa9bb82e1e271ba633ecdd1e1d7c28b04931524732a022eae6"
    sha256 cellar: :any, arm64_linux:   "2345460b218d43c1b847cd347ad0a3827c1ac2f84799a01131a9f1c5f8f04944"
    sha256 cellar: :any, x86_64_linux:  "4885e982367ef0c16e74da1eabba8c4695ce0d6eea395a4bb099efc66b72db2b"
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