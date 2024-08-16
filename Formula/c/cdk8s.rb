class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.189.tgz"
  sha256 "3852b11404b636493847a3c4fd3644f0df338d0142e6560cc9724259bf297c06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6962637c3cd9f890692b9bf66eeed197ca52681d078cc8eb81110a0827a0fa7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6962637c3cd9f890692b9bf66eeed197ca52681d078cc8eb81110a0827a0fa7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6962637c3cd9f890692b9bf66eeed197ca52681d078cc8eb81110a0827a0fa7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9e4ab6ffa6204fd5a668b3294c1ab3a3f91b29ec22bc288eeef6d2c1526199"
    sha256 cellar: :any_skip_relocation, ventura:        "fb9e4ab6ffa6204fd5a668b3294c1ab3a3f91b29ec22bc288eeef6d2c1526199"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9e4ab6ffa6204fd5a668b3294c1ab3a3f91b29ec22bc288eeef6d2c1526199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6962637c3cd9f890692b9bf66eeed197ca52681d078cc8eb81110a0827a0fa7e"
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