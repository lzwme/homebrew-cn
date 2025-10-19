class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.4.tgz"
  sha256 "731525840a9c2a1cf494943881f0d3c24aa75eb0d357e4373d4ffad18df914f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63f0765c9ceea5aca6ae03876ecd4865149f6ce54b149e0588b87f03d4e53b18"
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