class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.380.tgz"
  sha256 "aee03a46faa800d288b015961e97403765f149fdfa620113a612a8916d5b40e2"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa63c7ca85162af939cd602b1a52f6e140fdd379136436f43c21e149419e0e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa63c7ca85162af939cd602b1a52f6e140fdd379136436f43c21e149419e0e94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa63c7ca85162af939cd602b1a52f6e140fdd379136436f43c21e149419e0e94"
    sha256 cellar: :any_skip_relocation, sonoma:         "e883f77501f55e5ed85ecb50e770894d02a5e93d90b7fdea4e61956a18c5bc57"
    sha256 cellar: :any_skip_relocation, ventura:        "e883f77501f55e5ed85ecb50e770894d02a5e93d90b7fdea4e61956a18c5bc57"
    sha256 cellar: :any_skip_relocation, monterey:       "e883f77501f55e5ed85ecb50e770894d02a5e93d90b7fdea4e61956a18c5bc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa63c7ca85162af939cd602b1a52f6e140fdd379136436f43c21e149419e0e94"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end