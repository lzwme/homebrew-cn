class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.27.0.tgz"
  sha256 "38dcb33cc47fad5055703b90290ab9c5532d2f720d90458a7e118fbdc97a00f1"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476cdbef31f41c4d469f6bc07e2878475bcf9a3d903dcd96e64117d3bcee5926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476cdbef31f41c4d469f6bc07e2878475bcf9a3d903dcd96e64117d3bcee5926"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "476cdbef31f41c4d469f6bc07e2878475bcf9a3d903dcd96e64117d3bcee5926"
    sha256 cellar: :any_skip_relocation, sonoma:        "43390df47e6c3e0c9449b857c44313c5c9eede0bc581bf38570a4d510d7efe5c"
    sha256 cellar: :any_skip_relocation, ventura:       "43390df47e6c3e0c9449b857c44313c5c9eede0bc581bf38570a4d510d7efe5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476cdbef31f41c4d469f6bc07e2878475bcf9a3d903dcd96e64117d3bcee5926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476cdbef31f41c4d469f6bc07e2878475bcf9a3d903dcd96e64117d3bcee5926"
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