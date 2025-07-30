class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://ghfast.top/https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "bb7bd90eacebe505f2c669e4e13dac57c43c9c0eb5eca94dfa1378fd7cdcda84"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25393e318980c100fe1184a47e181346d1c6ffb3bd0276bf760b9401bbf62b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0acbef75ae52f0fbdefb6790660788351a7cd877b9776b7c2b0d93fae6fdb4ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac0bf4187356dc7f6b7329228bc7b7905e91cef1ca51546bb24865181571650b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e6efe5d35e2f1749d1a86188c81c77c2b8346d346919d799aec9bd0cb40daab"
    sha256 cellar: :any_skip_relocation, ventura:       "5f21f5e0c0b4ee28ea12d736bc8162992ddf2eeadd8265738d747446a062f41f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5109816b1476bc201acd40c7d7708162c6d00a211e72e61c2b75989089535c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4481ddaf02a5ee21477781bc30c5a9aed785737b0967bc3a4d129bbe166c089c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    read, write = IO.pipe

    # We need to capture both stdout and stderr from the listener process
    # the node ID is output to stderror and the listener data is output to stdout.
    listener_pid = spawn bin/"dumbpipe", "listen", err: write, out: write

    begin
      sleep 2
      node_id = while read.wait_readable(1)
        line = read.gets
        break if line.nil?

        match = line.match(/dumbpipe connect (\w+)/)
        next if match.blank?

        break match[1]
      end
      refute_empty node_id, "No node ID found in listener output"

      sender_read, sender_write = IO.pipe
      sender_pid = spawn bin/"dumbpipe", "connect", node_id, in: sender_read
      sender_write.puts "foobar"
      assert_match "foobar", read.gets
    ensure
      Process.kill "TERM", sender_pid
      Process.kill "TERM", listener_pid
      Process.wait sender_pid
      Process.wait listener_pid
    end
  end
end