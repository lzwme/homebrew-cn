class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.0.0.tgz"
  sha256 "022df67b4200efc466e8551b3f16437048c4e921883aa750b078288f39e4b2ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9498c67376a8ee7f553bb904803abe67aed38c19bd939c56615a433c94a55143"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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