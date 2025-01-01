class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.17.1.tgz"
  sha256 "761592d0d7420be9d178d8e395213ba90adbf9a6372bd9617e81bc35c4576e23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97b383102a67fffde63446083104cf39847089b7e17b78ecbed0ece6ef369900"
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