class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "500726be513e8f6e007e87523a627c49c1c53bbc97894c692e8b085ba69df3cd"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbfe64b7485afcbf8d7a03284c4718be5e0a3412a6bee3b84edf4c457773feee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c732758cec7097f1f0b4e45c246b797cf02569eb9cef1ba0d7ea9aab496b04c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0db638180a742e6faed5fa90607894c15520acdfba71452f7c38b0c7bea7c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f0e6f4d412013f3e5c221bcbd70db6601cebd4b88d932f89aeff598bbe4d473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46a300ef2113c004abe3754334d3081ca7324efc52e66d4b792456722c616320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b2ee3968bd71d9d5db8888f4828a4ea09fc64f0d49c907f1480ee3681855b6"
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