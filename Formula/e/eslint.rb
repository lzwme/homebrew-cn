class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.25.0.tgz"
  sha256 "814489eec09213fca4983be215de1d9b83636861f6312920bec11aa7cfc7578e"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876cad325dd622ce8af5976b1e1640ac79c967b6313d5e31a418bf5b33f9da1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "876cad325dd622ce8af5976b1e1640ac79c967b6313d5e31a418bf5b33f9da1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "876cad325dd622ce8af5976b1e1640ac79c967b6313d5e31a418bf5b33f9da1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b30d6fa4dd3b35f0d57eaf68b744bfe37c9feb82a706066269c9ae9898ab9954"
    sha256 cellar: :any_skip_relocation, ventura:       "b30d6fa4dd3b35f0d57eaf68b744bfe37c9feb82a706066269c9ae9898ab9954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "876cad325dd622ce8af5976b1e1640ac79c967b6313d5e31a418bf5b33f9da1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "876cad325dd622ce8af5976b1e1640ac79c967b6313d5e31a418bf5b33f9da1c"
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