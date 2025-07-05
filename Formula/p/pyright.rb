class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.402.tgz"
  sha256 "c0f45ed549c216f1aea353f8888a9a38744790be195a73541188853f5159453d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3827ecac141476826e527f7e5f9f61b5b1b7d159c8a495cd7efedcf4f51f7109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3827ecac141476826e527f7e5f9f61b5b1b7d159c8a495cd7efedcf4f51f7109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3827ecac141476826e527f7e5f9f61b5b1b7d159c8a495cd7efedcf4f51f7109"
    sha256 cellar: :any_skip_relocation, sonoma:        "e41947cb3e846fcba9f53a1cc4ff48d38420476ac38475c306e6c54750ce8f56"
    sha256 cellar: :any_skip_relocation, ventura:       "e41947cb3e846fcba9f53a1cc4ff48d38420476ac38475c306e6c54750ce8f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3827ecac141476826e527f7e5f9f61b5b1b7d159c8a495cd7efedcf4f51f7109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3827ecac141476826e527f7e5f9f61b5b1b7d159c8a495cd7efedcf4f51f7109"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end