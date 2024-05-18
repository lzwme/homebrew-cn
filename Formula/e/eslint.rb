require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.3.0.tgz"
  sha256 "e5c31a199dd44d259dc01a805b33e2cb8f7a868594345208d48cc1bcd1b4c9e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc08c21715035e2b131945c76eddbe944bd7b8ed2b6e50d9f0d92318015e3f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd05b79fa3befd49dac08acf8bc4d75d2681dd45708dc40c7ea7ca27f69384c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6583a3ce69341e58d30d48a45b23395cca7584dc788d55a517939085f904d83"
    sha256 cellar: :any_skip_relocation, sonoma:         "b62cedf3a454116242b932cc3d6c39d4791c643222474277f735515433301c12"
    sha256 cellar: :any_skip_relocation, ventura:        "c24d585a0343bf9805531716bf81780df749c2ff8ddc801999d33301103d22b0"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7c1f0d52a74c7534f16ae93c40fdc48a366afe66b8d15fcc9c337705d37465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e9db16e01ac9f607e23197fcb911a5360da0ca0faf86a250d7885e249062ab"
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