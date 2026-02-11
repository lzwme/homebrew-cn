class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.7.tgz"
  sha256 "885805432d55efc22aed48e6480779b8ee147de595371f0cb2dad2964a7204b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7384f49c30a02ba92bf903b9ad41e7f45f87cd87b7b2a79facff8b0929ccf2d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end