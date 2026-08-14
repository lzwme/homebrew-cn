class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://ghfast.top/https://github.com/tlipinski/rura/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "b0a4126d515d9e48b3445dca5c6407e3b86a882398f0661f605a9e1a6e695bd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a1c836556ef55c5f475e53e303c1ea47998b6512d99d3fd0aae4789ab4b59e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a4abafd3b7e723b3d9abce4236456c2440afc4271601ebdd2d8ba9947e764e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bfba0f030dc0eee04faa745c26d0467fca05b302c25bbc4d074b03384d77f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "53555242601252b6cc5ad23dfea5e3e7b93a51215e9200063c3bbfc082590139"
    sha256 cellar: :any,                 arm64_linux:   "dfa003153fb88f9d6f90c8d65cf070f9843a1e155a5f2994b9283c2acc9d45c8"
    sha256 cellar: :any,                 x86_64_linux:  "7b3e00fb4b24b548b38691f96e48902d65152932c56c8d38e93ae1b747384232"
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