class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://ghfast.top/https://github.com/tlipinski/rura/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "56c909d07cf8baa4dcded2665d4cff881232a0d7ff0bf2685b05071cb5ac4ed1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc270818a4eb2ec98936224475852be5aaac2177edc12f10f21a0228ec8e5129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e48e4105ced6a9ee7aa8c55a3be7212a72610dd856257ffb6aa7bf96e59d28d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840e7112a466bd0104d84bb340dbfdec591bbb226aa27b236b7b0a8a8401c5eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3190c9be710065cdcbd336664bf6a0756e530cbc8991841e790dc937d73cc997"
    sha256 cellar: :any,                 arm64_linux:   "a88f4694db9aef6f9e7b52923673acfc490033faace669c9a5f9bd2aea841f78"
    sha256 cellar: :any,                 x86_64_linux:  "27b2ec5f5c149a0baf8aabd70de382d3b12e105689b6bb2e383365e00f7408b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "expect"
    require "pty"

    (testpath/"test.txt").write <<~EOS
      Hello
      world
    EOS
    PTY.spawn(bin/"rura", "--file", "test.txt") do |r, w, pid|
      r.expect "1 Hello"
      w.write "tac\r"
      r.expect "1 world"
      w.write "|sha256sum\r"
      r.expect "1 bdaadfc45abaf"
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end