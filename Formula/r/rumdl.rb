class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "554ac23ffba4677ef1a28ca556fd3067f018ee71eba703c58fc904a1dc4fd9ed"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "037d80bf0f95f127e3ac18c2c0e657d0ee5455aa0f64072be1b06cbdf44b03a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3872a2f27d96f8a33c6189b8534a23c3daa2317f93ea849f65ae42a6301685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e16396759f0be473a23111cab8657dc5d7efb7d195a883ad1c0c26df5032b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f5e2ee4b267c2244334fead76dfa5db70423d88c082df14a249d23702a73e20"
    sha256 cellar: :any,                 arm64_linux:   "ce365fb5595bb5f99801e66fcdfe06fdaa4fff25ae7ce2bac321bcd7aa38b24f"
    sha256 cellar: :any,                 x86_64_linux:  "66198486348c3854fb077c1a54703d3f2e54200a45338dd11f35d454e4fd5f16"
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