class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.10.tgz"
  sha256 "fdbea646b4491b3cceba22c6bfc303955f749e4bbd591836366d0e80af8ab088"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b553df5049a15b0d6b3a674aeff56bbae8a675933769f2bc56237e3d581eb72"
    sha256 cellar: :any_skip_relocation, ventura:       "8b553df5049a15b0d6b3a674aeff56bbae8a675933769f2bc56237e3d581eb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end