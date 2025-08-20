class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.0.tgz"
  sha256 "ff29adc568de0b4a92d519d959803fc7476bffc0fcf906d7f99956fd5ac1b05a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df8108e2a05a3eab1db4bc76a834d56dcbb2795ed4639d0dbecceff44f594eb0"
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