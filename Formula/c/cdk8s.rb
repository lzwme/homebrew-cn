class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.41.tgz"
  sha256 "fe706b0c8a692f6291d3f31bc02f334ffd3857ee7d62385535476c3d10ccb8f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f203fd34d99684fc92c22cc2a92a715b3a32f81e44fa534a57cc26bc04f117f7"
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