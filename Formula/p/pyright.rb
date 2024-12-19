class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.391.tgz"
  sha256 "24439c0e5bf0a0b14db0f3104bb7ba6d5d522f92a7d4d67e1023048173e0b1dc"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2123e2d46dbc35e5eb01bf3fd9b5dc956d07ebf5541dded644e1426da9864db0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2123e2d46dbc35e5eb01bf3fd9b5dc956d07ebf5541dded644e1426da9864db0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2123e2d46dbc35e5eb01bf3fd9b5dc956d07ebf5541dded644e1426da9864db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b206838efb93e02aafb120773f069f4bca1df1b20cd47b669e8e172f7d5d5d"
    sha256 cellar: :any_skip_relocation, ventura:       "23b206838efb93e02aafb120773f069f4bca1df1b20cd47b669e8e172f7d5d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2123e2d46dbc35e5eb01bf3fd9b5dc956d07ebf5541dded644e1426da9864db0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end