require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.35.0.tgz"
  sha256 "cb628feb2347e769b56df86017b96429c8ac236ccef3df0c7d96a7dd16131d68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91af595162feb75cd3f9b001abaf7ca06293c5913ee0b0dcc8cff66954e84a75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91af595162feb75cd3f9b001abaf7ca06293c5913ee0b0dcc8cff66954e84a75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91af595162feb75cd3f9b001abaf7ca06293c5913ee0b0dcc8cff66954e84a75"
    sha256 cellar: :any_skip_relocation, ventura:        "8a9e2ef43a8e5fb7c25b7f4cdebeb11dc31abc03c1f55d421d935e561999d83f"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9e2ef43a8e5fb7c25b7f4cdebeb11dc31abc03c1f55d421d935e561999d83f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a9e2ef43a8e5fb7c25b7f4cdebeb11dc31abc03c1f55d421d935e561999d83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91af595162feb75cd3f9b001abaf7ca06293c5913ee0b0dcc8cff66954e84a75"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end