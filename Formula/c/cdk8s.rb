class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.5.tgz"
  sha256 "95a81cf3ee86c9b65c134f56dc3086ed81b55e79b1a191f2f239a85f4397586e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca64800d5ddd3aa5d95ed8b53f13c05434df19664f22d1e0d9680261a93fe7ef"
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