class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.394.tgz"
  sha256 "68fff0726d94afa6e44fa0faf447f25349b92d6d4e5cdc73289b84ba40f7ffa6"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cbc8b616744d9427a7e22a2d40259a040a3cc6c825973a41c3b0b9bce493b73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbc8b616744d9427a7e22a2d40259a040a3cc6c825973a41c3b0b9bce493b73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cbc8b616744d9427a7e22a2d40259a040a3cc6c825973a41c3b0b9bce493b73"
    sha256 cellar: :any_skip_relocation, sonoma:        "05fccdf75037b0259a92da4b273959bf926dc109fc15c21f43256c0b01ae1b70"
    sha256 cellar: :any_skip_relocation, ventura:       "05fccdf75037b0259a92da4b273959bf926dc109fc15c21f43256c0b01ae1b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cbc8b616744d9427a7e22a2d40259a040a3cc6c825973a41c3b0b9bce493b73"
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