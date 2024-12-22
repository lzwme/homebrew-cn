class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https:eslint.org"
  url "https:registry.npmjs.orgeslint-eslint-9.17.0.tgz"
  sha256 "1f5dfb1a392972604ee2b4dbcff6c7a9413e06804f130ac4025203fa7015dc2a"
  license "MIT"
  head "https:github.comeslinteslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5570ad93798f59edaa3dca6ed16b04061ab7e56fd8c574e850249079adee996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5570ad93798f59edaa3dca6ed16b04061ab7e56fd8c574e850249079adee996"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5570ad93798f59edaa3dca6ed16b04061ab7e56fd8c574e850249079adee996"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f82ad19880347bf7f78ea4447717b83d72cf73d1de3724d8275e35c26d167a"
    sha256 cellar: :any_skip_relocation, ventura:       "57f82ad19880347bf7f78ea4447717b83d72cf73d1de3724d8275e35c26d167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5570ad93798f59edaa3dca6ed16b04061ab7e56fd8c574e850249079adee996"
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