class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.70.tar.gz"
  sha256 "33cd083f1c764da2dc79f8183c1e74eea6fbdc310a6d911b2d960ed9c07e95fb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c0a6b9b7d4208e4911a66232e3792976e4874ebb9633d8a57f78efad1ce560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7381f66550b1d3d526b6dc1e5b2cbe37552539240467731afb6ba1f4a4561a00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad36f52a37f14ba47a8145285acee17fa4ca197d25f2d8d822d429bf774b12f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e76277c7bc2749ed1c1a963f82d583a620afb93d38b1d486a6cae5805f2f059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "287f85bb5e4b375e98b0ffab79b0dec9f8171552eb521f07f3a42fd7566129e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b0e041caa9f7a80dd2cec04ac649d170470f541a97a3d163a3540599275cd32"
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