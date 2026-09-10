class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "08f74b81ca05f9e7da085693cd1ae142137c30426d390b7fe1d095e15f772b4b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f31c91ca2546ad9567c64ca2c1b9573a766dab523ca0510b3a6e168f0756ad7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d15b66fa4088b8aad348dfc03510482d21866d3db2f428fd222bb99021b501e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c0b0243e3bcaaf65e4c9b65a93f3331ac11678bc0c28771e686c08be93fa67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc393ed3ac51581f38bb029cfc8e863e438da836346cc7da03e53580e1dfebc9"
    sha256 cellar: :any,                 x86_64_linux:  "088a3c2b836039e4e060a4f7612ac27fa1e60395c098a71953680f76a4d3dd16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end