require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.6.0.tgz"
  sha256 "618ace32d7af16dfd9cac514f30ba6994d1dc259c2486b596c3e0884ec775dbd"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e976e00a25999150981cb01d1653723c554d1be03e83d58446f6b93750082c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e976e00a25999150981cb01d1653723c554d1be03e83d58446f6b93750082c9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e976e00a25999150981cb01d1653723c554d1be03e83d58446f6b93750082c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "503e409835e6bdeab4a1b907a479d8508c9a981d9224a5e9e9a4c74ac065c08a"
    sha256 cellar: :any_skip_relocation, monterey:       "503e409835e6bdeab4a1b907a479d8508c9a981d9224a5e9e9a4c74ac065c08a"
    sha256 cellar: :any_skip_relocation, big_sur:        "503e409835e6bdeab4a1b907a479d8508c9a981d9224a5e9e9a4c74ac065c08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e976e00a25999150981cb01d1653723c554d1be03e83d58446f6b93750082c9d"
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