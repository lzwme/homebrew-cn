class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "5f110d3ea88884200161d286cab56bc808a59f614f24088c5e8dec619f3a20a7"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f17018a95f2b04425a33a32ef4b5c83f36c4cb18f5fa49959ca00ec194cc1497"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63b21fa04b499fd90ae168a840df13d7ca41bc09f5f239951f7bbb17158b8f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33f803b751a2836fefd5e2bd42fdf8bfaa17cca05960e86cc6db99cff58deecf"
    sha256 cellar: :any,                 arm64_linux:       "ce60711486f813bf06142c8b8f09ff12e48f0afb33a9af620e0f044482e040f7"
    sha256 cellar: :any,                 x86_64_linux:      "a9063e7dea3eaffbc4b841f63c8b7359d4ff15722ede7f303fc050b544f0c997"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"treemd", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/treemd #{testpath}/test.md > #{output_log}")
        r.winsize = [80, 43]
      end
      sleep 3
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end