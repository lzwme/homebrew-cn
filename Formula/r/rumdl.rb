class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.79.tar.gz"
  sha256 "748aa833adbe3851ae538547260dfd38e965f7a62e8cbc24da4382987e87c457"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a3efb122ede702e1a39d120178eae489bfb0b543e92ef9aa284fcc07da4c21f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a264a3ce53c6a2ad46a276b66950dacb16a192efaafa4c55fb9ad1ea257008e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98ecd4123ebc3150113d3291baba863382292e7ddf00f4f630a8abcba69e7fb7"
    sha256 cellar: :any,                 arm64_linux:       "6a52103ecba1d9220fae3b4fedc2d51fffd8ea2e65b7ae3819b3d6ee453e626a"
    sha256 cellar: :any,                 x86_64_linux:      "6b3afa00164fa06db24c975338b680845eaec03054edcf59b1b6f21f19591d8d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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