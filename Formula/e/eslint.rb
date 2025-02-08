class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.20.0.tgz"
  sha256 "3357141d0a24d187d404d011ef16af319165af970822e988e27bbdfa1da853b1"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d23262fab0baaba0f0274de543f37af5a857e02d1f4173e64dcb87c7d64d9af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d23262fab0baaba0f0274de543f37af5a857e02d1f4173e64dcb87c7d64d9af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d23262fab0baaba0f0274de543f37af5a857e02d1f4173e64dcb87c7d64d9af"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe3ffe38993b543fe2ffd55278aa498dd1c36978d8d469638b7fbb1fec6bcba4"
    sha256 cellar: :any_skip_relocation, ventura:       "fe3ffe38993b543fe2ffd55278aa498dd1c36978d8d469638b7fbb1fec6bcba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d23262fab0baaba0f0274de543f37af5a857e02d1f4173e64dcb87c7d64d9af"
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