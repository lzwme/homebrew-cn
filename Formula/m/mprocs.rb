class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://ghfast.top/https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "806b46bc2a3b4369c4e1e35cf4c6e57949ee14919d1b2ff09bd1a21a57cb7a56"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f71ae0895c4e9daa8111b5b32809b240dcc4ff0b516aa2eee5e482a2450c517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c7c91c92fdd5dcb7095f48e862585027cd74f72378e073351a643bc8184737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93dc1f8857042c52495b296ffb6689ff517e02ae878247062f633e54f412b668"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8e03d510c206f730f2582c4a97b487a4c5aacd9fb9df7c2fc77ece1c5217c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b0a6e63f1d6aec549819e47be6c3673d2d3fc33b0605e0162a470d6b5c8d063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e97920a8825b34775df141ff374b5c4031ae17fcd0b5e52d04c5f5cbd65f2646"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end