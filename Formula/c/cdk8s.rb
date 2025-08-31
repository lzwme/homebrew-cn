class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.10.tgz"
  sha256 "a0ac441cd93cf7467b62aee7671481904060bc293c53b136332a4a7208677720"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5eb4ab52b09a1cf5f41ceaa97bb72922b0130d19c2391ee8c5fb0788853ea0bf"
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