class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.3.0.tgz"
  sha256 "749bb90008db50322862b57f6b4f5149bae7e63611eb8a3f9bd67d32e113cfca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1312cfe94fbdf193efba9b57b58b007e43a1815bdeaa7a5764d617e8f8f81613"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end