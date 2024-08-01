require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.374.tgz"
  sha256 "a5f7d706de74ee63231b4e2def32ef65faadc06c3eabc61c8213da45e34d34c6"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "009ae6c6a27f3a2603b881abf15e6a6d404f80a76ee7d2951ff523b907f4602b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009ae6c6a27f3a2603b881abf15e6a6d404f80a76ee7d2951ff523b907f4602b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009ae6c6a27f3a2603b881abf15e6a6d404f80a76ee7d2951ff523b907f4602b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8cb4e0195bf4d3c884c603ee3eb2c134f40af83562fe7d090c0baa22e000ccf"
    sha256 cellar: :any_skip_relocation, ventura:        "f8cb4e0195bf4d3c884c603ee3eb2c134f40af83562fe7d090c0baa22e000ccf"
    sha256 cellar: :any_skip_relocation, monterey:       "f8cb4e0195bf4d3c884c603ee3eb2c134f40af83562fe7d090c0baa22e000ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f226ae19c72217e34a77a995495e2651faf984af68a1d25ff6b8836e18d37615"
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