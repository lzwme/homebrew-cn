class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.38.tgz"
  sha256 "8fb076296b0dbce1b5f813f66fd8f3761d72a6d897d091e4a1674a2f1197165e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7ca2bb0eceea8112a416f015939370156a63269d7d9813ec669c207d1a427f4"
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