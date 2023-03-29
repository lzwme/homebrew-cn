require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.5.1.tgz"
  sha256 "648995fb1cae7da3bfee115e5599ae705c34b6155080f91e1393e8fa9c927aa2"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dc1e09a54041d2d5fe547667c16a3965b140044d9072af627cf9e2ea350de52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc1e09a54041d2d5fe547667c16a3965b140044d9072af627cf9e2ea350de52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc1e09a54041d2d5fe547667c16a3965b140044d9072af627cf9e2ea350de52"
    sha256 cellar: :any_skip_relocation, ventura:        "3c375926f3fb7e5b646bd8cdab528000d4225bfee29126b5dfccb4848fe1d729"
    sha256 cellar: :any_skip_relocation, monterey:       "3c375926f3fb7e5b646bd8cdab528000d4225bfee29126b5dfccb4848fe1d729"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c375926f3fb7e5b646bd8cdab528000d4225bfee29126b5dfccb4848fe1d729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc1e09a54041d2d5fe547667c16a3965b140044d9072af627cf9e2ea350de52"
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