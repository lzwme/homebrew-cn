class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.35.tgz"
  sha256 "733fb43a7fb318d4f4450c754976f7107fee0a7a391e5c6b296bc731c2136e51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15bc7e0a9ec1c153b68009e6d795c98bf230b4d60e8b13e7fd8936c912154315"
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