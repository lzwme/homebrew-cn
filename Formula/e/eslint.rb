class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.21.0.tgz"
  sha256 "b2c645b692552457f580a1ff72e2b37a303879f8cebcad02129abaf13355fb37"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "372eac964812120316ccd90ce0794ec54358f3845477294da88b38552257eef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "372eac964812120316ccd90ce0794ec54358f3845477294da88b38552257eef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "372eac964812120316ccd90ce0794ec54358f3845477294da88b38552257eef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d4678928bde59cf2695a826e253a8f257020aa7a9fcf323daee4648ba7245e"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d4678928bde59cf2695a826e253a8f257020aa7a9fcf323daee4648ba7245e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372eac964812120316ccd90ce0794ec54358f3845477294da88b38552257eef2"
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