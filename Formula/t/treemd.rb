class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "28a857b266ef9ae5591b914260b058328fd0dbaf1c04e7617891e6ccbac64000"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35933b807ee46956f92d8967e123c61283d430aa308bea01c4448a6dea279216"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e20df3fa0646a492ecf7596b3152dba20a713deedb355793324efce5ea906784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81907e5c8d7a2f244121bb72ad4ccaa21d6384c99e643a2f6f2e43e5ab5677cd"
    sha256 cellar: :any,                 arm64_linux:       "c1024e19dd2c74b6d9aa877dab849b7f1d1df226298e0569b26abea31051a782"
    sha256 cellar: :any,                 x86_64_linux:      "7eddd92db534fec7f60e16041515c77d1ed31357ecaff13a08957a2feb346d6e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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