require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.76.0.tgz"
  sha256 "154cefd5fa2b6594303d27f20a4a252f550b89e434ce4b252cd1967f450d3865"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c833e93b4b29a9860566b4bfd8b2dc80942a803912f28cd523aea816c8bf4070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c833e93b4b29a9860566b4bfd8b2dc80942a803912f28cd523aea816c8bf4070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c833e93b4b29a9860566b4bfd8b2dc80942a803912f28cd523aea816c8bf4070"
    sha256 cellar: :any_skip_relocation, ventura:        "e88b9650990e5eb91af14e48b8930d85a3f5455a3c46c171f41e7497bdc82d89"
    sha256 cellar: :any_skip_relocation, monterey:       "e88b9650990e5eb91af14e48b8930d85a3f5455a3c46c171f41e7497bdc82d89"
    sha256 cellar: :any_skip_relocation, big_sur:        "e88b9650990e5eb91af14e48b8930d85a3f5455a3c46c171f41e7497bdc82d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c833e93b4b29a9860566b4bfd8b2dc80942a803912f28cd523aea816c8bf4070"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end