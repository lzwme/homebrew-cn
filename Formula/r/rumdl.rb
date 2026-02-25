class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.28.tar.gz"
  sha256 "1d1d737d0e52f74d31bfda4a686e0132ce6e9c7015ece05905a68c094f9cf1e8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "014c5e9c91e85316af44a34eadeb2535a7e59f81f2ac7778229790ea5d4482dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c53127fd24317b8ff5b6ac6b82336db5334ea537bf15ff02a84a369af947a1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b8eae2dc2e426fa5f8468d8c907431abdcdb86bb1a36d30e8758a5526a1ac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25675329abacb64246b28a54cd2ea1b1fd152444a30da1e8bdf8bebfd88b00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1ebd8bec31ed9a9aa4a10f66a96920cb9c88dcb405b68981295faa6d011b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f2cf70a7d593175b00b45b3d75fc48bba445a46459891c59204a93fe8e0acd1"
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