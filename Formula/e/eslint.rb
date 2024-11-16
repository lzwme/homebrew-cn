class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.15.0.tgz"
  sha256 "8a400a3c6ac4cadaed2d7c2656ca4ac2d98722ddaf5d8e615670b72557b4e77e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c5ac218b5d4f99327ff8d39e867b9c0e35832b4301f04d35fe413d1e467afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c5ac218b5d4f99327ff8d39e867b9c0e35832b4301f04d35fe413d1e467afe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c5ac218b5d4f99327ff8d39e867b9c0e35832b4301f04d35fe413d1e467afe"
    sha256 cellar: :any_skip_relocation, sonoma:        "b97983e4cee200074cd7c8df1585663fb70e7b3a6d65efcb337793fc0eef202b"
    sha256 cellar: :any_skip_relocation, ventura:       "b97983e4cee200074cd7c8df1585663fb70e7b3a6d65efcb337793fc0eef202b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c5ac218b5d4f99327ff8d39e867b9c0e35832b4301f04d35fe413d1e467afe"
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