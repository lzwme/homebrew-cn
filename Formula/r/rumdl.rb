class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.207.tar.gz"
  sha256 "93772563373f8f575d0c45325548e796f773332065f8d5f1dca2a4f3d14b43f1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a95a8702075914c0b16f066a2ff6e23c762090aa17120eae5af9164b7fef8fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7392fee734fdeb1f968b70ba2c7656c2d775e4c01cb63ab6f7f461b6ed3ae584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e222cfc0eb880e140d5a122f12830dfd59c0a1a54bc03b0cd23380b98e2d2ab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5472d1516c895f5c5cb66e0ddf3aa783f9384269b8888db350b0fe44c28a3c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3376281f3f846cc0bef6a9ff77218b398f3f8658d851fd9102dc6fd9832e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a146dfcfa7b5028ed11ec25eeda614358ab70a69c7fc85fdf8b14e1f59e6bbf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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