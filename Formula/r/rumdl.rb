class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "4b0cfddeae635a5c8ce54dcbcd62401ba8c57008cefe3ec9eb7c7f6604ae8a62"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15cdb4b09857e56e885a3bb7d26d1c800da97235c3912a2cf459e2c35f151f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7be194bf1be9b61aee19c30e5136f18d49054c0348a65226747b8d3b4e48b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63bb8d340e47bfa5758d0dccbe751caa84aa9dcbd45d11411d601cc09536956b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c84f484c45a67738a788ee8eb7705411683ed62a9e488659e4a451a56e17e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a92087fb40dae56272b7ce3ee104e1d30f4cbb6c6494d84adfd931419111c877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a573cd0d40b61e1c2f8d6722a48fc8b61d31480000cd5f69777bf208e7317fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end