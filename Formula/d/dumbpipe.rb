class Dumbpipe < Formula
  desc "Unix pipes between devices"
  homepage "https://dumbpipe.dev"
  url "https://ghfast.top/https://github.com/n0-computer/dumbpipe/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "9ac9261fb618adc161a57b48a3fa42b73a856786604cb1778e11657d8125fbeb"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2256150c1188bc8537df3b2669f8229bbc6149595cf2ceb396700d8a6d5ed007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f373aa015dc531d5c6d150deffba6e0ef96b66fc66adc54a5bbfc2510ebc30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "467018d6d5458f55869f90c0291d12b1fe32c6811faf451f625b7f17089237f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf400591d3b0e86fe51dc26882c95761db7035e5b2cd1cae1939b05acd11d3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4c6c3945a972467afdc89900a9902c9630ad265e6c27da22791e28d705516a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f617bb08e610f7fe1693ceb56edfb923eaa27ac3b31d025db6a7af04dda1ee61"
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