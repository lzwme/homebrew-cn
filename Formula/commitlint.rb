require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.7.0.tgz"
  sha256 "f2b541e462dd2efa4da35dabdf4154b8368dd1e3e0f99ccca3f4424b2ae1907e"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "825cf1ef187a6a42c0217290b8658cb3d757be5bc2960998069f1207aacc91db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825cf1ef187a6a42c0217290b8658cb3d757be5bc2960998069f1207aacc91db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "825cf1ef187a6a42c0217290b8658cb3d757be5bc2960998069f1207aacc91db"
    sha256 cellar: :any_skip_relocation, ventura:        "247adf89ed6deb61fb9aed15bc229cc402e664f1005a4af51e157cba10dcb49c"
    sha256 cellar: :any_skip_relocation, monterey:       "247adf89ed6deb61fb9aed15bc229cc402e664f1005a4af51e157cba10dcb49c"
    sha256 cellar: :any_skip_relocation, big_sur:        "247adf89ed6deb61fb9aed15bc229cc402e664f1005a4af51e157cba10dcb49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825cf1ef187a6a42c0217290b8658cb3d757be5bc2960998069f1207aacc91db"
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