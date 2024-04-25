require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.360.tgz"
  sha256 "3c782cbc09ff6338f252cf0eb2891d474789e9d5cecef0dc9cc7434e3c221d47"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3aa25e4423c9297ddde5c938e6673c8df46f9c70cb853862d56c8037d015f964"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aa25e4423c9297ddde5c938e6673c8df46f9c70cb853862d56c8037d015f964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa25e4423c9297ddde5c938e6673c8df46f9c70cb853862d56c8037d015f964"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef830a1bc324f470297ea613b75b08c60955cabd9e3f64e0a857f06d5222e618"
    sha256 cellar: :any_skip_relocation, ventura:        "ef830a1bc324f470297ea613b75b08c60955cabd9e3f64e0a857f06d5222e618"
    sha256 cellar: :any_skip_relocation, monterey:       "ef830a1bc324f470297ea613b75b08c60955cabd9e3f64e0a857f06d5222e618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa25e4423c9297ddde5c938e6673c8df46f9c70cb853862d56c8037d015f964"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end