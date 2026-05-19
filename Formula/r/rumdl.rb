class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.94.tar.gz"
  sha256 "2f6122330280fc360bedc55f85e823cf5300fda3a0b4c4be0f6219e96c2816b4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89c515b5b9dc6f25f0bc9d6438ff556b2933b1ebc9ab618a2c47364eb13644b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500c998dc9535879df291c0be3b11e8f56bace0ed0207ddd2f1037f05a4fbcd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "795ddf506178f2ff626966e421fa3db7c9d9c6eb97208470eebcbacb67c47616"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ede75abc9b34eb229c571bef98659ed4469d93d527eaa7e4a08c12b00263402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecffdf67d4b9ebc32918e308e5c3bf334b33bcb0e7244cd195e4eb43e244bdab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb3ab2f26431131f670a33d7770f7115f1911d8d60926096d55abc98f45640d"
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