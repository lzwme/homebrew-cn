class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.10.0.tgz"
  sha256 "734343703675ae5cfbe44d98173eb601e187551e64618d8153aad8ec36db9714"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a7f15a49aba1f1c08b681a3dd237273230c280f3bfbfa5368575d737a81c985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a7f15a49aba1f1c08b681a3dd237273230c280f3bfbfa5368575d737a81c985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7f15a49aba1f1c08b681a3dd237273230c280f3bfbfa5368575d737a81c985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7f15a49aba1f1c08b681a3dd237273230c280f3bfbfa5368575d737a81c985"
    sha256 cellar: :any_skip_relocation, sonoma:         "b19219a20ceeb0d22e40f8f42eb5b29f95869d0ee3bfd2408fa9147936d328a5"
    sha256 cellar: :any_skip_relocation, ventura:        "b19219a20ceeb0d22e40f8f42eb5b29f95869d0ee3bfd2408fa9147936d328a5"
    sha256 cellar: :any_skip_relocation, monterey:       "b19219a20ceeb0d22e40f8f42eb5b29f95869d0ee3bfd2408fa9147936d328a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a7f15a49aba1f1c08b681a3dd237273230c280f3bfbfa5368575d737a81c985"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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