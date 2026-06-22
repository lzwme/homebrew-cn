class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://ghfast.top/https://github.com/tlipinski/rura/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f846498085c644fa345339e28e8855121448a2f0ec37df805365e5bd9555903d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f966f35c1b296b511f71f88000c77d6da63f709fb69d196c4baaae8a1b5203c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b5f3af61808ea8b76fdb07384808205b7f8436c67cf942c2df5be5cf04f86bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a06f53a31f16148f51ec36c4b45da19387541cd55e2dfb2912f9fcca693ef74"
    sha256 cellar: :any_skip_relocation, sonoma:        "16a6fccc7cd970055d7ac38adb3b6c8c9039391996470b1bb3cba297d7c7405f"
    sha256 cellar: :any,                 arm64_linux:   "b1f2cec9a205ecaa4133b928428e2a452cf5b265000aba8b6a4837629fe0b5f0"
    sha256 cellar: :any,                 x86_64_linux:  "cef155da73c1592b84b67a04627912ebbc92caf00ed15b65ea9c5fea1b11c1e4"
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