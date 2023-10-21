require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.0.0.tgz"
  sha256 "5af2b3438bdc926b9104bfd85ac9d7ca942156efa22f97850b67dcde5a82e10c"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42c39d871bb3a957e192cb795be0347c3ae031392fdc86e6b0934ca1031c34fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42c39d871bb3a957e192cb795be0347c3ae031392fdc86e6b0934ca1031c34fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c39d871bb3a957e192cb795be0347c3ae031392fdc86e6b0934ca1031c34fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "831f424823d40c8657b0c9be39368deaaa29f33d991055424ffafdca6fc5add3"
    sha256 cellar: :any_skip_relocation, ventura:        "831f424823d40c8657b0c9be39368deaaa29f33d991055424ffafdca6fc5add3"
    sha256 cellar: :any_skip_relocation, monterey:       "831f424823d40c8657b0c9be39368deaaa29f33d991055424ffafdca6fc5add3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c39d871bb3a957e192cb795be0347c3ae031392fdc86e6b0934ca1031c34fe"
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