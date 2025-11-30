class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4bf2d3e7eddc23a77f823ee2b6670426949c5a6e6fa155e83309a9c6db8548f4"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34dd0cf22e6c5e58f5dfe3aa1acfa1c3195efd346e03717f902f4a6c9b5a868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2bc7e40eff0b59507b53fad56e4666dac47bfc93c9e7fcb7de9477bced8e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e3ce6313742a1b1bc47346c5eb68a2998c2a2466bcec9e983ce74d188121dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b81f0fbe4e28c0680d10a90f072df76d8d45cea9397a145891f44a4d7a63b84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee23178e14605db1e81d434ce42aa3670f27bc26ade190b7778cca979f3fe1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "588f531b4e2b76d03fe8bec86c96abc11e3013c5389c93f3abd6691ce4d9c32c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end