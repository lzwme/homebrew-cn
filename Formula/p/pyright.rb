require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.365.tgz"
  sha256 "5a590bc56286210bd7238c715de6b0e9f738d86827f9874c3019b36a4f8455f4"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a267fe2cb26eb6061b246f97718ed63f8ee088b5871faa012809ca73dc2246d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a267fe2cb26eb6061b246f97718ed63f8ee088b5871faa012809ca73dc2246d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a267fe2cb26eb6061b246f97718ed63f8ee088b5871faa012809ca73dc2246d"
    sha256 cellar: :any_skip_relocation, sonoma:         "11580abb9f3811e7581285d4ecf373c6c716faddd88995a5511e3e9aded4517a"
    sha256 cellar: :any_skip_relocation, ventura:        "11580abb9f3811e7581285d4ecf373c6c716faddd88995a5511e3e9aded4517a"
    sha256 cellar: :any_skip_relocation, monterey:       "11580abb9f3811e7581285d4ecf373c6c716faddd88995a5511e3e9aded4517a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8973b9259a0e22d925dc71c507f25aee7d50660087232d60c04e9b84ee0a2dd1"
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