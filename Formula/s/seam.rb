require "languagenode"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https:github.comseamapiseam-cli"
  url "https:registry.npmjs.orgseam-cli-seam-cli-0.0.39.tgz"
  sha256 "af448c0864801fe34466b2cb5c397a7774fcbfe3bbdae23bf046a1cd44fa4e09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c30df84acb3804850cf637aa16ad8380532c7bd87c0063a6408b73c013090791"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c30df84acb3804850cf637aa16ad8380532c7bd87c0063a6408b73c013090791"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c30df84acb3804850cf637aa16ad8380532c7bd87c0063a6408b73c013090791"
    sha256 cellar: :any_skip_relocation, sonoma:         "40ac16e4f218c19217742985c75aa2a5510cf97285ea6709e3d4b6d525dcdef8"
    sha256 cellar: :any_skip_relocation, ventura:        "40ac16e4f218c19217742985c75aa2a5510cf97285ea6709e3d4b6d525dcdef8"
    sha256 cellar: :any_skip_relocation, monterey:       "40ac16e4f218c19217742985c75aa2a5510cf97285ea6709e3d4b6d525dcdef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30df84acb3804850cf637aa16ad8380532c7bd87c0063a6408b73c013090791"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end