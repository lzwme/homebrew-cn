class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.18.0.tgz"
  sha256 "566de56262f44a57b42e1c826ea2c4aa079f64e4311998209ec6ce28e227ec13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "303e9b596fafdd3297aa78236f7d71d85a07bdf9deaeaa708f4874d2941b73ef"
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