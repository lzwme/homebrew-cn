class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.46.tar.gz"
  sha256 "15bf62f4f9b2da2ca53cee8994f64e18c11e332b4e81adc5ef992029c7fadfba"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c01b1882f14a228ce8998adfc5743b6df74b8ef9879f00f70c023b37206810f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dcbabc87f36e8a2c4bbb7628d0c0c1c07be1dafe139a7aac87ef8c666847ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30fcdfa76004dc1f0f4196a6cec6e12ac6b9c15e2f24256d38c60e8f712cd3b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a47299dbc87b4d6da913e9215b36d30c0eea5ad831661369296f6b05a0ace52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71aec9137e255828ceae6b7dd80a368a8bf6d9ed0989a01b652121e153e7388f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a06a34df5bcf816a0caf6a9c7f2aed88f0a231b1161473ee5429736cf481ba"
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