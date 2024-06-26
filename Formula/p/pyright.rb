require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.369.tgz"
  sha256 "1c970a0871031e9d8b3eb6cdbb7296e2a930f88b5eb1caf26e73b0b23e91e5a4"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9550eb5c2bbe774c2927e73623b529f44fea557c114c9b122d2170c10b7078cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9550eb5c2bbe774c2927e73623b529f44fea557c114c9b122d2170c10b7078cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9550eb5c2bbe774c2927e73623b529f44fea557c114c9b122d2170c10b7078cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfc53064060a138ebb8ec7bd7c9ea9b91f72c60796f8458a9d3d6bcfc39a3c04"
    sha256 cellar: :any_skip_relocation, ventura:        "bfc53064060a138ebb8ec7bd7c9ea9b91f72c60796f8458a9d3d6bcfc39a3c04"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc53064060a138ebb8ec7bd7c9ea9b91f72c60796f8458a9d3d6bcfc39a3c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "187ccc4af6bf62f37ecafee2886f1d25912e6914a0496b58638d5a41af0ae1d6"
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