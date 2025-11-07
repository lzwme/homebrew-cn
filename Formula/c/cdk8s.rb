class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.0.tgz"
  sha256 "3c26c0267476307c2ebf481e38a25a245155d53da148cc6edaa58d6e462d6a24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5b86db9e02423de934d1e58a57da692897aa052ff60879cbcb39f3800f1572f"
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