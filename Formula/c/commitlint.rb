require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.2.0.tgz"
  sha256 "c325d93ccd803a9f4eeefd5cab482553adde35f0f4d41bbfaedd531a6cc758ff"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d8d1128361b9b208d5a3b021fa783c37b10fa9035777e1e0bca03da5d74c309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d8d1128361b9b208d5a3b021fa783c37b10fa9035777e1e0bca03da5d74c309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d8d1128361b9b208d5a3b021fa783c37b10fa9035777e1e0bca03da5d74c309"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4ff8dea23688f3e990f8a4ada8b9818d3167a52bf46f119baed4774203f39e3"
    sha256 cellar: :any_skip_relocation, ventura:        "f4ff8dea23688f3e990f8a4ada8b9818d3167a52bf46f119baed4774203f39e3"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ff8dea23688f3e990f8a4ada8b9818d3167a52bf46f119baed4774203f39e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d8d1128361b9b208d5a3b021fa783c37b10fa9035777e1e0bca03da5d74c309"
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