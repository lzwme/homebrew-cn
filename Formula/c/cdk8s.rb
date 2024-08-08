class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.182.tgz"
  sha256 "0b18fbac93e552980273a898c32efdce953318fa5ca7f48585113e6e306f3e73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c7c92264dfaa9456977de15e2681c65a966201ccd756266510955c01b90a306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c7c92264dfaa9456977de15e2681c65a966201ccd756266510955c01b90a306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7c92264dfaa9456977de15e2681c65a966201ccd756266510955c01b90a306"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1383fd451e2511c6a19d1ade3ef53256d04033ecf5fefd5c8ccac4420b5cfce"
    sha256 cellar: :any_skip_relocation, ventura:        "b1383fd451e2511c6a19d1ade3ef53256d04033ecf5fefd5c8ccac4420b5cfce"
    sha256 cellar: :any_skip_relocation, monterey:       "b1383fd451e2511c6a19d1ade3ef53256d04033ecf5fefd5c8ccac4420b5cfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b642aa21407c4cba4450e24b2c135448546ab78bd08c8b75c7945e58bac007"
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