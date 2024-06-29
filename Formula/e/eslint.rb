require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.6.0.tgz"
  sha256 "0b6f858d08b38698d6dc9981889e4a252b0721f2898dc49c538ce785fd0b1c7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dd7222b19630d2f37b4631a89abc65e238b00a33ac3ca40c9f4ba7c9ed4b309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dd7222b19630d2f37b4631a89abc65e238b00a33ac3ca40c9f4ba7c9ed4b309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd7222b19630d2f37b4631a89abc65e238b00a33ac3ca40c9f4ba7c9ed4b309"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44dbcda16afaa7664ecaf09440958df4e3ac8bdb99422a6c0b1379ded8de15e"
    sha256 cellar: :any_skip_relocation, ventura:        "b44dbcda16afaa7664ecaf09440958df4e3ac8bdb99422a6c0b1379ded8de15e"
    sha256 cellar: :any_skip_relocation, monterey:       "b44dbcda16afaa7664ecaf09440958df4e3ac8bdb99422a6c0b1379ded8de15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b955613c3b9f9d59497559695932a1f1aee22f21195c4607a92aa7f7873c0abb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end