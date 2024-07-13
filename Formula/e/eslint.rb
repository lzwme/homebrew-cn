require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.7.0.tgz"
  sha256 "5536620318396eb45debb1f10757ee42c9c8d86fff84033738ebf62f2e28759b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "136a4ca8f98cb0e6cdb4ed910dc2e9fa0fb32e49c27989dfdb6ca2960eee98c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "136a4ca8f98cb0e6cdb4ed910dc2e9fa0fb32e49c27989dfdb6ca2960eee98c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "136a4ca8f98cb0e6cdb4ed910dc2e9fa0fb32e49c27989dfdb6ca2960eee98c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "61de5fea4283a26a8cd526c65c0ce5d788f783b7e3e6443f7fc3d37f393db72b"
    sha256 cellar: :any_skip_relocation, ventura:        "61de5fea4283a26a8cd526c65c0ce5d788f783b7e3e6443f7fc3d37f393db72b"
    sha256 cellar: :any_skip_relocation, monterey:       "61de5fea4283a26a8cd526c65c0ce5d788f783b7e3e6443f7fc3d37f393db72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23546f6f9b4ba7dbef9126cc1be668171ae17da7d364aafb7a59d2f6e6da4bfb"
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