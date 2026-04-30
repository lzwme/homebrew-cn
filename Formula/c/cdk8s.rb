class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.9.tgz"
  sha256 "01b08ac5725e5a6985e2ade83c833b686d0a313e6a8a6442c0851b3e4a14bdd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f843784a9c211063437e3e2b20ab5cf722e93689a854d4af433ad735b6a2f534"
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