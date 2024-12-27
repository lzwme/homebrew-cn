class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.17.0.tgz"
  sha256 "26cbe600c93755d6c778f9a499ddc77147d98c45ed56121274843100a86791e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "598660c0a8d8c36d2337b7e8d56e90b948712f887c721a7e1615dba7c6987af0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN
    assert_match "Summary: 1 error(s)",
      shell_output("#{bin}markdownlint-cli2 :#{testpath}test-bad.md 2>&1", 1)
    assert_match "Summary: 0 error(s)",
      shell_output("#{bin}markdownlint-cli2 :#{testpath}test-good.md")
  end
end