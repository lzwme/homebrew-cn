require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1290.0.tgz"
  sha256 "1fabccdd0d492be1bebc834d4252d86d1b66ea173379e4706b0b44946a8e8a2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc6f0d049241f49d6b5c9d57830c15abf348ff658de773119c589f6c8d10b60e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cb96516d6b4a35ea1e5b87fcaf3e3985fc0cc7d20f1237c7396a49806230cd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2620d0275f0aaf3fb0df125a2c11eaa777d9084bc1683393cc1f0461dd515e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "64ed5a1a314a6988fc8b5383dd5ce023291a10f4a85560d416e2fb1641898fcf"
    sha256 cellar: :any_skip_relocation, ventura:        "085000ee9eff4cad23e249712b91322bca60c81d62a3d06a7fb7046254c4b140"
    sha256 cellar: :any_skip_relocation, monterey:       "586fc026488960f2aca8b42a499feddd98871f99a7df38f8711df0b117d5140a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f760f20394294137f75c5d8ca812a2460fa822b59dcdb87847aef47825b4c714"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end