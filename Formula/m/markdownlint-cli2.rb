class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.15.0.tgz"
  sha256 "162969e38018574754f29749fff5e5a7520865dee5f1405553d93fd3f899342c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a1be8428d3ad13e4425b30edf80df03b28e706dcc79c0aa60dce92b2f85208c"
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