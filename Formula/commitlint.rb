require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.5.0.tgz"
  sha256 "9adc27eaea1b4d301e468da1ad47e0eeb5d9409877ab4c4c97daef608d044204"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f747f8481182d02472449871c4a06301a5a7c01198d58391f8e02beff0130eb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f747f8481182d02472449871c4a06301a5a7c01198d58391f8e02beff0130eb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f747f8481182d02472449871c4a06301a5a7c01198d58391f8e02beff0130eb5"
    sha256 cellar: :any_skip_relocation, ventura:        "8b06730f4d7d7c7e9ea6f70ffff7c18f7747bf3f9d07eb61ae25f6d6182ce34f"
    sha256 cellar: :any_skip_relocation, monterey:       "8b06730f4d7d7c7e9ea6f70ffff7c18f7747bf3f9d07eb61ae25f6d6182ce34f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b06730f4d7d7c7e9ea6f70ffff7c18f7747bf3f9d07eb61ae25f6d6182ce34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f747f8481182d02472449871c4a06301a5a7c01198d58391f8e02beff0130eb5"
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