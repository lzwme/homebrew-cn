class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.16.0.tgz"
  sha256 "67117b732b3bc1303dc58100d7cc56f2dbe75297b045cfe04d2b30dfd5d7a213"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b56e00869ca949ea8d282bbd71d984553a1d006aebffd24604d489b41bab412d"
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