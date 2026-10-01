class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "0a47aa4f0fac15d6b87f37a3a637c65ccbb6a16a25a3fdd86f679e8a2d43fb4d"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4911e0911ff9fded020cfeebd5b6f730a64b6935775fd6f199a44dd20d82d043"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7053d3a92ebd74249c676ce2293a90bcfea8e0bb38630a88949c78d3f4a7788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1e96f7914f61738294a5716bc763522909cef23245e3dccbc4432d1880aa4b1"
    sha256 cellar: :any,                 arm64_linux:       "c4b479717c3b6df879f4232bc28325ef7204aab8fcc48e5b86108835effc112e"
    sha256 cellar: :any,                 x86_64_linux:      "6c0834e249062e763b5e42905f153e61fe808e40b34b5b888cc78f73ee295f40"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/serie > #{output_log}")
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end