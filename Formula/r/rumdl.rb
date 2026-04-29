class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.84.tar.gz"
  sha256 "8f139394fedfc6582bc494afbf68beae4b0e9baec6e505267cc65c087858dcdc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7524410d4ec2637d74d6ec1b4cea7af0d2a9161266c1fe208b5ddfc4bf6e69a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3cccd0b49ac6c709b11972af5705e8a27cf50707f23658b829eabe609302586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da5b72f12df35577115f9da31e43af7ef83e963ea7702d4105e07c90865c33ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "eebe29c7e6fc25b623a2a56b04ba804f703b462e9c0995cae7ec5da80b41b610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec057296892517308af454b74ce87bf15094bcbc8de67d1625d959cc7b88e7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4096d6adbf63498dd71577e728f369f0fb0af3c51e39de0130a1e64a8f4d539e"
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