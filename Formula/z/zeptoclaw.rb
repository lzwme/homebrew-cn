class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "896a7bb3765e017bd112d4e9a0fcb85866f8a6e9bd6c6c744e1ae010a55fef65"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00adb15c529f72f173e2fb495210e0048f7f3e1fefff37d2a77a5c6b06edf6d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d70761cc451fa608b074a98c1d5d2e17ab0245e1413a979708469e31298290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc9264c332b70c8b56e44f349f688f0d0d4a4c3196fba361c909ef6f0b22c4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff7586b302c8a149100d902e9d44b292bcc0156c58e66b3e084c5c2366d4916b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6679ba5ca53590cc6a56c0e5f3b8d66e16ecf6d9cbc023bcc17b754babcfd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6dca0773fba7ee8a254f3592d78b6132b176a27de205faeb173b0e80c0b3d1"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end