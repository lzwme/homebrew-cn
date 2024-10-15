class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.246.tgz"
  sha256 "dbbd4307af5719246333f2f6a89237904a58508131b95a16a7c2eb0cff57bdd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c1732e6112583af49d853d8bc7a7f5b458b98fbc0a4218851609d82fe9d1d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c1732e6112583af49d853d8bc7a7f5b458b98fbc0a4218851609d82fe9d1d6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c1732e6112583af49d853d8bc7a7f5b458b98fbc0a4218851609d82fe9d1d6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bede4ca40fa57181a2edec84975a0930f67979a29718ae8ca73114af7786d260"
    sha256 cellar: :any_skip_relocation, ventura:       "bede4ca40fa57181a2edec84975a0930f67979a29718ae8ca73114af7786d260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1732e6112583af49d853d8bc7a7f5b458b98fbc0a4218851609d82fe9d1d6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end