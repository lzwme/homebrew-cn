require "languagenode"

class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting MarkdownCommonMark files"
  homepage "https:github.comDavidAnsonmarkdownlint-cli2"
  url "https:registry.npmjs.orgmarkdownlint-cli2-markdownlint-cli2-0.12.0.tgz"
  sha256 "34978e8ec951412009bb028cc66488fb90107b507a290fd13e35bd52e6707aa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2fde227c63bc0fa8d899c0f5da824365497fa41b2480e0ade788fffec87e5b8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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