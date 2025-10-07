class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.46.tgz"
  sha256 "c5f35504a70f8b5cd92a2e82bf8d665874f3ba410e0f71c639c825ba7f71f9b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0e5777506645240f5217d4a574be677b24b071f8bbf51febf5a166249f1828f"
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