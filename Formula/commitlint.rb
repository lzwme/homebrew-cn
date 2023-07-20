require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.6.7.tgz"
  sha256 "464cac15f868f9e030a76892f1d95c8b799d840a1e468e9cd6e64fccb0ae94ba"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "630f2cf0e45e374c8c6cf7fd14d4cbde714c66a692cd91282bc91d6652f73233"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "630f2cf0e45e374c8c6cf7fd14d4cbde714c66a692cd91282bc91d6652f73233"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "630f2cf0e45e374c8c6cf7fd14d4cbde714c66a692cd91282bc91d6652f73233"
    sha256 cellar: :any_skip_relocation, ventura:        "1e3716c188469b2ab64ca045ff6bd8f80898c8ece8038efce235f17ed9cc0efc"
    sha256 cellar: :any_skip_relocation, monterey:       "1e3716c188469b2ab64ca045ff6bd8f80898c8ece8038efce235f17ed9cc0efc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e3716c188469b2ab64ca045ff6bd8f80898c8ece8038efce235f17ed9cc0efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae95653bb43e0a94578546688c2d1e1c740a17ebc6321f4d19c570f55003878"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end