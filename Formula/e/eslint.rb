class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.14.0.tgz"
  sha256 "9f9db5976b508c2ece3a3563d6cc2c0d7fad81b0a18661cf3d007b29a1df6893"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a07a065da9c9c3ce5d5c499783782316059578d891267d4a628681214d7451e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a07a065da9c9c3ce5d5c499783782316059578d891267d4a628681214d7451e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a07a065da9c9c3ce5d5c499783782316059578d891267d4a628681214d7451e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e1aa93c665ca2089baec9d51d2758bc6d36f05bf8db47d408cc32d2795132e5"
    sha256 cellar: :any_skip_relocation, ventura:       "3e1aa93c665ca2089baec9d51d2758bc6d36f05bf8db47d408cc32d2795132e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a07a065da9c9c3ce5d5c499783782316059578d891267d4a628681214d7451e"
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