class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.8.tgz"
  sha256 "e24ed33e96b098d11184b23083b4cb9c4bd12ec923f27dab07c96a2bb164d48a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f36b84459cb0da4ebfc864f7cb48123ad10a16dc51209072863b6f0d3292a42"
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