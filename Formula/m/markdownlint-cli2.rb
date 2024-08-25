class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.13.0.tgz"
  sha256 "db7d09de0f934fb8146b5a2a01a819faf361aff36099de3030825d75ae1c4178"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "81b77966383084e4a7ec3d7556009c231a21781e64d0e8df836791bf8884f902"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "Summary: 1 error(s)",
      shell_output("#{bin}markdownlint-cli2 :#{testpath}test-bad.md 2>&1", 1)
    assert_match "Summary: 0 error(s)",
      shell_output("#{bin}markdownlint-cli2 :#{testpath}test-good.md")
  end
end