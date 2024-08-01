class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.8.0.tgz"
  sha256 "6953308aa17ac5b1383d080f3e82ef8fcca4d558be45f4c1d9c8a15fe271f1e4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ef0881fcbc6e973866e801f74f35373e138287606604a896501ff6c8b57561c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ef0881fcbc6e973866e801f74f35373e138287606604a896501ff6c8b57561c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ef0881fcbc6e973866e801f74f35373e138287606604a896501ff6c8b57561c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd2c78b40116486b9d34bbe3884c850485e41d18ac2a9321a3d4619d178ef688"
    sha256 cellar: :any_skip_relocation, ventura:        "bd2c78b40116486b9d34bbe3884c850485e41d18ac2a9321a3d4619d178ef688"
    sha256 cellar: :any_skip_relocation, monterey:       "bd2c78b40116486b9d34bbe3884c850485e41d18ac2a9321a3d4619d178ef688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29465b475ca8c3c895b813e7f635c6c03c06923e5e3e1731fd630b8865459b09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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