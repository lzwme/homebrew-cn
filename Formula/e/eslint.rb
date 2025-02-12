class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.20.1.tgz"
  sha256 "8ed03bd6d1684ab8698abb71de1bdadc6f39640fbe866936be95d684bb662a6d"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9a5ecbee0cfa89d1ed627a4dac0fa732915827fc1761f0b365afb3a97e87f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9a5ecbee0cfa89d1ed627a4dac0fa732915827fc1761f0b365afb3a97e87f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9a5ecbee0cfa89d1ed627a4dac0fa732915827fc1761f0b365afb3a97e87f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4afef07487dd8314ca8cab73c79c93c42701e2ef4ee86a13011892d522b5bf"
    sha256 cellar: :any_skip_relocation, ventura:       "de4afef07487dd8314ca8cab73c79c93c42701e2ef4ee86a13011892d522b5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a5ecbee0cfa89d1ed627a4dac0fa732915827fc1761f0b365afb3a97e87f01"
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