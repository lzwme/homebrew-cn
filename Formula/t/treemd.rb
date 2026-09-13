class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "aa89c2c48c5741f8c3d8c52dc7dd544b6d96f73d54dc612cfd9d3f22f6eb1289"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8c209f086e8d50758a4db0e128ebbe6e72d12318ed75d8acf99820682ef4017"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1431f19bd160a209d52ec0986cca695b4bd3b6bd99801cde6672a5347e9a9b0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45cd9b7f78b93bbee5590d561e5ac795fc3c09e90fcda171aa259ed4061bbee3"
    sha256 cellar: :any,                 arm64_linux:       "5587f8a4d41ed79513d38415c468bc428567a98a3eaceebd44584f5da0a86153"
    sha256 cellar: :any,                 x86_64_linux:      "9fa820b48f7055ac554b47e14f7f3c3c85ff78cbc4d43f2f4afa92694594d2d3"
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