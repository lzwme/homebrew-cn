class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://ghfast.top/https://github.com/tlipinski/rura/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "53f7ee8e24cfce1bcf1c7c51239db7f493a696f7b94e6d2519016599c560b025"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "675107150c2e2ffb446f608c9e56b8c0ccd49f22e73fd16cf6d5f18c6e5194f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2756b88f5fa5762695b9eab08ebde5257aa9c975a2c78b0e1d26e96e0c7aa50c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe3030a7c408cf55576801f6e73f2063902e263d99ab24d77942600ac826e3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "295ca61b9569866f071a7fb76bb48e00e2905179c460032e588cd6dde996687d"
    sha256 cellar: :any,                 arm64_linux:   "62a16ae11db87d9767d131b8a23c18e5b23cd7b9ce119d565b732d79a7b4f1e6"
    sha256 cellar: :any,                 x86_64_linux:  "d3ed068d8b800d1b98e3c7a4b68f7454f1f8bb25f35a5416aebf2e6893bdf428"
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