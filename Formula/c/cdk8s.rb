require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.6.tgz"
  sha256 "8628786f0f3e29489abc57e6de0b7193b7d7417b08151a6328c95d31865742ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2e78474e761bed9fae634f6435eb61d6149bc92a4596b53fbdb0fb32fc17118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e78474e761bed9fae634f6435eb61d6149bc92a4596b53fbdb0fb32fc17118"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e78474e761bed9fae634f6435eb61d6149bc92a4596b53fbdb0fb32fc17118"
    sha256 cellar: :any_skip_relocation, sonoma:         "155a45da13e95668466c27cf6e48d9fbbd8be438d03dabc08ea4ecd7eb4af0f6"
    sha256 cellar: :any_skip_relocation, ventura:        "155a45da13e95668466c27cf6e48d9fbbd8be438d03dabc08ea4ecd7eb4af0f6"
    sha256 cellar: :any_skip_relocation, monterey:       "155a45da13e95668466c27cf6e48d9fbbd8be438d03dabc08ea4ecd7eb4af0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e78474e761bed9fae634f6435eb61d6149bc92a4596b53fbdb0fb32fc17118"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end