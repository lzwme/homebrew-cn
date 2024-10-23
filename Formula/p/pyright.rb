class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.386.tgz"
  sha256 "d68e4f1dc593975a5253eca16e56970ad001298de5b744688c65e735030ee471"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b631c0d847dd2fa1a616b9e817ab8a00e422001ea92e9e0ed4f1a655a5a94e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34b631c0d847dd2fa1a616b9e817ab8a00e422001ea92e9e0ed4f1a655a5a94e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34b631c0d847dd2fa1a616b9e817ab8a00e422001ea92e9e0ed4f1a655a5a94e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e97d42a302fd68195c4c391729eb8f84cdffc61a8517a32e5d1cfc7ae88425"
    sha256 cellar: :any_skip_relocation, ventura:       "44e97d42a302fd68195c4c391729eb8f84cdffc61a8517a32e5d1cfc7ae88425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b631c0d847dd2fa1a616b9e817ab8a00e422001ea92e9e0ed4f1a655a5a94e"
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