require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.336.tgz"
  sha256 "dc5ca7d4582fbeacf15a385276daa2b610d6c92cb45d736b42884b01d99116e5"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e52e92c085b98889e005eb3ea329d96b095a4f60642a54dd0c94c15a9f792fc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e52e92c085b98889e005eb3ea329d96b095a4f60642a54dd0c94c15a9f792fc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e52e92c085b98889e005eb3ea329d96b095a4f60642a54dd0c94c15a9f792fc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e41d5681897c1da55a96136ab83112643089c66df05988540532a7bb3c074244"
    sha256 cellar: :any_skip_relocation, ventura:        "e41d5681897c1da55a96136ab83112643089c66df05988540532a7bb3c074244"
    sha256 cellar: :any_skip_relocation, monterey:       "e41d5681897c1da55a96136ab83112643089c66df05988540532a7bb3c074244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a791db0e7a7e6f99fce75dfd2335961b4fa4c6589c6d4cffb7768a676d2bd77"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end