require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.4.0.tgz"
  sha256 "377de15a6886b1f973688a5b9e96950ac1431c773392eff4ae927e1b7cef5424"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f4f438305aaffd620da6c53df1b5fdada1217fd5a5c529ef890d470da7958a"
    sha256 cellar: :any_skip_relocation, ventura:        "12f4f438305aaffd620da6c53df1b5fdada1217fd5a5c529ef890d470da7958a"
    sha256 cellar: :any_skip_relocation, monterey:       "12f4f438305aaffd620da6c53df1b5fdada1217fd5a5c529ef890d470da7958a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
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