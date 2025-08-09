class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.33.0.tgz"
  sha256 "950f0551355e47801ffd1556f0fd588c3d3e69c770bf782ac1649830ef4f86c6"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19393bb61d9aa7ae7121a9296c5be3fee2981d7fd03eae442d28e1ded46646b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19393bb61d9aa7ae7121a9296c5be3fee2981d7fd03eae442d28e1ded46646b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19393bb61d9aa7ae7121a9296c5be3fee2981d7fd03eae442d28e1ded46646b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2e5ed12cbcf5383e0d71063a031366bb345708afaa797cb59838e45fdd03c59"
    sha256 cellar: :any_skip_relocation, ventura:       "a2e5ed12cbcf5383e0d71063a031366bb345708afaa797cb59838e45fdd03c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19393bb61d9aa7ae7121a9296c5be3fee2981d7fd03eae442d28e1ded46646b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19393bb61d9aa7ae7121a9296c5be3fee2981d7fd03eae442d28e1ded46646b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end