class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "996e17df2e361f1b11cd626d210d6e820aa8c9c38c09d5d09e8b00dbdcc81abf"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "958f7dc622caf58181f1b8ba4ecddfb3d434538ed57ab2b7aa7b4c2301cfda5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48f4bce80697dd319d145606195f040ff50622129bb25f9580da0fa7ff33202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56921598a689a62d1e53d2a9c387b0bd26adf5f4da5e6c835c8b7e3c4184cfb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "792d6d3883b5e41c318a487b006d068f0d03783ae4701500a043daf57ac97b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b830afe8a75fb8cb4f823ba2de1cddc899a928c0845701176a01c389073fe07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a5e08fc57366e8c2362af2e77f5151da97597ccce9b0d5f409c2dcee22e7509"
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