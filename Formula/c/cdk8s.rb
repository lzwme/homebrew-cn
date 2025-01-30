class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.308.tgz"
  sha256 "5547cde2ed35cfb0c3aabf405c5b4ec271bd7363ee8b4275923a38d246f8b4d4"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aadd8a5b48d16f846369b67ca3084b7edefcc449097b66b61f4e96f82e65dd18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aadd8a5b48d16f846369b67ca3084b7edefcc449097b66b61f4e96f82e65dd18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aadd8a5b48d16f846369b67ca3084b7edefcc449097b66b61f4e96f82e65dd18"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b7a44875b96418a4de69ae6fb587b078838648bf3e1418569017c7100a5557"
    sha256 cellar: :any_skip_relocation, ventura:       "e4b7a44875b96418a4de69ae6fb587b078838648bf3e1418569017c7100a5557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aadd8a5b48d16f846369b67ca3084b7edefcc449097b66b61f4e96f82e65dd18"
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