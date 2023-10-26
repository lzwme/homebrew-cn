require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.1.0.tgz"
  sha256 "04127efbac6966c7d0977bbf8deb1bfacebfd814d8d179480f15da8b251434dc"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c937c288344bde54847b1cd078433dfaae76cbde00191db846a6918e30dbf6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c937c288344bde54847b1cd078433dfaae76cbde00191db846a6918e30dbf6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c937c288344bde54847b1cd078433dfaae76cbde00191db846a6918e30dbf6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ae43a7065861ef01ff64a11620a8fe1749a930069ff2965101fd4306c9e9875"
    sha256 cellar: :any_skip_relocation, ventura:        "1ae43a7065861ef01ff64a11620a8fe1749a930069ff2965101fd4306c9e9875"
    sha256 cellar: :any_skip_relocation, monterey:       "1ae43a7065861ef01ff64a11620a8fe1749a930069ff2965101fd4306c9e9875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c937c288344bde54847b1cd078433dfaae76cbde00191db846a6918e30dbf6d"
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