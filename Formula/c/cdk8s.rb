class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.9.tgz"
  sha256 "111af54cd7b94f514a3b359a6ff7580b910dd3cc394d349ce05aecd8231cdea5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10743321cabdc021da20a1cb971c5fc9d789dbef5b4fb85d7885b97b486f453b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10743321cabdc021da20a1cb971c5fc9d789dbef5b4fb85d7885b97b486f453b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10743321cabdc021da20a1cb971c5fc9d789dbef5b4fb85d7885b97b486f453b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd0724ac0ea407b5833f5c6b1b9f05b61eadce00d1b26a6f8ae3c1b0d34f7560"
    sha256 cellar: :any_skip_relocation, ventura:       "bd0724ac0ea407b5833f5c6b1b9f05b61eadce00d1b26a6f8ae3c1b0d34f7560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10743321cabdc021da20a1cb971c5fc9d789dbef5b4fb85d7885b97b486f453b"
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