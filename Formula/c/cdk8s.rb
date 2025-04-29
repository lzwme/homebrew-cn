class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.54.tgz"
  sha256 "4538cff53d344feee9a7ea071e0b201d7d6c8414c6b70cb34ac3787ca777382d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b874ac870c5770692e888ddfca9c98a6c0cc2cfc11f0255b904db95bb30b096c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b874ac870c5770692e888ddfca9c98a6c0cc2cfc11f0255b904db95bb30b096c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b874ac870c5770692e888ddfca9c98a6c0cc2cfc11f0255b904db95bb30b096c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f19318eb5eef24035ad18798af16398f4e4d6b335f7450401493e384c9204ad"
    sha256 cellar: :any_skip_relocation, ventura:       "5f19318eb5eef24035ad18798af16398f4e4d6b335f7450401493e384c9204ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b874ac870c5770692e888ddfca9c98a6c0cc2cfc11f0255b904db95bb30b096c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b874ac870c5770692e888ddfca9c98a6c0cc2cfc11f0255b904db95bb30b096c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end