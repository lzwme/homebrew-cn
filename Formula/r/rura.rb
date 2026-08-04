class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://ghfast.top/https://github.com/tlipinski/rura/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "af88f649ad0be5fd55639b50d3ebcd716afe1e6130fa52a21bb13f1727dbeaaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad6b0699e6c893e871cfdfc899e8fd58f3a6e11aa104b36dc362722dd787d94b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994a7f96e8c8d5ef688d6693a95f71aaf8e4256b4f1b56235be6fd041b496e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580737ea1fbede91c6f5623bb333aaa3158f5429a9d659bda720705b529febec"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec89e9d7ed7e93bcaa43b40d990fb98d61cfa5e95ed73f8a3ce9630a1c259917"
    sha256 cellar: :any,                 arm64_linux:   "c431e71d9159824c455591cf07725741f8e2427379434fcf6ac2268b90317760"
    sha256 cellar: :any,                 x86_64_linux:  "bc65b59b8a083a5e06f3ffd3d16079193a46eadb37001b26fe335de79645db0a"
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