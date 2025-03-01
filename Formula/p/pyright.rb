class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.396.tgz"
  sha256 "5bbe6286ca3ad6613af6114bdd1c64cb3f1be669f7b50fb8013f5ac7b9387772"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8408c8c7ebca66b998956e84f3de23f10795b40cbfa23287013c52940801cf2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8408c8c7ebca66b998956e84f3de23f10795b40cbfa23287013c52940801cf2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8408c8c7ebca66b998956e84f3de23f10795b40cbfa23287013c52940801cf2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0f04e37d48c263abc2211d3a4d1ca98f441e768373644ba83e3228f2d8f6604"
    sha256 cellar: :any_skip_relocation, ventura:       "f0f04e37d48c263abc2211d3a4d1ca98f441e768373644ba83e3228f2d8f6604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8408c8c7ebca66b998956e84f3de23f10795b40cbfa23287013c52940801cf2d"
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