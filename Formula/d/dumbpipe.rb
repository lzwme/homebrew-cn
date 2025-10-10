class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://ghfast.top/https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "66393044299dc241db16e58f57d10d8919db10c65791c3b6088dd58396261441"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e95ea4cd6f1dc1ff9174a4cdbaaab6fa01db8b1e477f944cfb46e5ebd1f37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22d2bb53e80c7aec2a1d2e5920c523dece1154ed8ae844d3b10d79516bb5593a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b156f8a8a4a279fc38e404c06286a82019e3d04a13985abd9c0f1d001a9976"
    sha256 cellar: :any_skip_relocation, sonoma:        "28e6a84490bc0956e61c29a09e61bd66c46c0bc427143098a65c1406f6de35e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f3e1839a284a4f5dfe1d71ba3a2bb7a9a4d2cd401523af90fe1927728219e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff3e4592076aea7c01822bd8fccf676fc172a74240457b950340051aa71f085"
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
      sleep 10
      node_id = while read.wait_readable(1)
        line = read.gets
        break if line.nil?

        match = line.match(/dumbpipe connect (\w+)/)
        next if match.blank?

        break match[1]
      end.to_s
      refute_empty node_id, "No node ID found in listener output"

      sender_read, sender_write = IO.pipe
      sender_pid = spawn bin/"dumbpipe", "connect", node_id, in: sender_read
      sender_write.puts "foobar"
      assert_match "foobar", read.gets
    ensure
      Process.kill "TERM", sender_pid unless sender_pid.nil?
      Process.kill "TERM", listener_pid unless listener_pid.nil?
      Process.wait sender_pid unless sender_pid.nil?
      Process.wait listener_pid unless listener_pid.nil?
    end
  end
end