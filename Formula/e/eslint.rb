class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.30.1.tgz"
  sha256 "cbc47991b05e8269f02d15221df001cc640b4c2b9f3898e800c8f7df930afce7"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e20f35370279975c082711347f7932eb722d45341e4702b63b7cdf9322eff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e20f35370279975c082711347f7932eb722d45341e4702b63b7cdf9322eff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57e20f35370279975c082711347f7932eb722d45341e4702b63b7cdf9322eff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4c62ab5755303779bf14c34fc010255441e316c662b2c10be40cf82a1da044"
    sha256 cellar: :any_skip_relocation, ventura:       "bf4c62ab5755303779bf14c34fc010255441e316c662b2c10be40cf82a1da044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e20f35370279975c082711347f7932eb722d45341e4702b63b7cdf9322eff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e20f35370279975c082711347f7932eb722d45341e4702b63b7cdf9322eff1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    # https:eslint.orgdocslatestuseconfigureconfiguration-files#configuration-file
    (testpath"eslint.config.js").write("{}") # minimal config
    (testpath"syntax-error.js").write("{}}")

    # https:eslint.orgdocsuser-guidecommand-line-interface#exit-codes
    output = shell_output("#{bin}eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end