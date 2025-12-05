class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "d66a947ea705ded52bbc69859e84d4ccc9f8d62e698dd90be4b8a206c0c6995f"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73c3c8eb79e31e650ab8ec5daab2b4e317e9d022f39e5ff69e8d2e416916c215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4931a29d82e2c4c6e9f11dc548c92bf3b0e89876798429ed6eb5a0b5eaebc1d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff79015ecbd0d51f33ae0beedaf919a62a8a44fe48ae2e934caec6b09cb5bf79"
    sha256 cellar: :any_skip_relocation, sonoma:        "5333752411ece28b88e2cc186967d0e0837d08d67dbb2c57af30b156eb904b00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21aefc1a86bee24cd18c1b6c9ebaee80c444ec961406e73ca477ca56ea4f2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc2848a40312015be534630e41aa62f0dc2e000e66e9327527ec22fcd7d8b15"
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