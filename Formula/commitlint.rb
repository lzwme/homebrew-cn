require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.6.3.tgz"
  sha256 "920d6cd57651f410f0a323eec89bef52539bc0b3caa83667d19b47742bdfe683"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebd3a705b30ae3e8210115bb1e9e5d0539845891cd4279b11c0d995c79d35b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebd3a705b30ae3e8210115bb1e9e5d0539845891cd4279b11c0d995c79d35b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebd3a705b30ae3e8210115bb1e9e5d0539845891cd4279b11c0d995c79d35b1e"
    sha256 cellar: :any_skip_relocation, ventura:        "3a23419e38ae97e3b31638221182dc8607c99d34ba0a6cd38694d7c789448868"
    sha256 cellar: :any_skip_relocation, monterey:       "3a23419e38ae97e3b31638221182dc8607c99d34ba0a6cd38694d7c789448868"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a23419e38ae97e3b31638221182dc8607c99d34ba0a6cd38694d7c789448868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd3a705b30ae3e8210115bb1e9e5d0539845891cd4279b11c0d995c79d35b1e"
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