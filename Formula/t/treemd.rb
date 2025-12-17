class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "4f559a8d4ee9abc306db3bfa0e3ba57aff88784f107113d4ba6188e6339f7941"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65726ab794ea442d15518c18f7adf3460be805fd7f89fd7ef577e48fe7c1d26c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056fc9e2d038f1732d7b416d23c348ed24cbd33f05a953d23d2063d9f71149f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e581b680c3228bd403f14357c584ce01a16d375a089d385c46df13e35164f4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd20780881fc7bcf878da32afdba0b81ac87e8f0d9406df8e1349b48588b786c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71167dcb885c7b655c1d4bd18e14d378c90bebe157fca371b6edf1a22b78ee34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314f7747fbe47990d2a29465ae55b72c8259fde11bd208dc1edd7ca50186e848"
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