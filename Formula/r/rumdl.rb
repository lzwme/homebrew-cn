class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.67.tar.gz"
  sha256 "1d9e589d235593fa30295022fbf329a21335d9a5b11d9b762bf5ba4063f55f28"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99bce1299b80df21de794af784f849e6c34c4db7309b3fcdd97b09850a487684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f35a5e71c58b48199a602ea1f60ab81c1cce3f648c2ffef913ae1875805a7dc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375651446d41e81dd6705a5d2cfb4065c5e554fe4f3962cd893f9ae025a6fc3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef64bda4be2685be0efe1504c027f30b109df752374153e764239d49016cbfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df9dc21b03bdafeb395be3289673f4ef971cb3dbd13e3300d46cc6918aa442a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da35f4294ae382e9dd2c65eb557a817391ab5376a076971082499c21d66308d1"
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