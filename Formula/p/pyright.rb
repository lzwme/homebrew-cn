require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.364.tgz"
  sha256 "b4aaeb126a6d3e0e2678692297f573e9c0ecd2333f161ed961a174cfc8bc1c95"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cb3f72dbc134a6d6b2c80afa77e96026140b8744370ea221eaea3eb40532365"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "331d01218e09621a7c03694a89d5929a07701c4e4f8cf9b4af5626bd9491a03f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eb8500cc3ba88753819858bc19616920056822c9204a02b162839a18515a069"
    sha256 cellar: :any_skip_relocation, sonoma:         "42d09c896021769401cfa251782ccb2348b8762bb15947916170693a1841fdc4"
    sha256 cellar: :any_skip_relocation, ventura:        "a6d889a598b8f091873ebd939cfa1d02a75f17e617ce8c842a5cf8b8fd80278c"
    sha256 cellar: :any_skip_relocation, monterey:       "21b363c17b41fa47f800098f59b6f4ace22f350ff2e5fa31a919fae0e22ccbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4a8d5b2f6dbca3b05467b055bb70a1140204138470d80135d34387f0efe725"
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