class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.327.tgz"
  sha256 "9b6313ac0f08de20fb07ee50345a591552e138a980ae62b9c61eaa325cfe8391"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b082cbbe1baea58432858be93703e8bdd1a56eca1be3df161015c53a7cce663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b082cbbe1baea58432858be93703e8bdd1a56eca1be3df161015c53a7cce663"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b082cbbe1baea58432858be93703e8bdd1a56eca1be3df161015c53a7cce663"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3cc453444c0e94db36ac9f71934090f3faea391eb9f5c7836fa1b01751452a"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3cc453444c0e94db36ac9f71934090f3faea391eb9f5c7836fa1b01751452a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b082cbbe1baea58432858be93703e8bdd1a56eca1be3df161015c53a7cce663"
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