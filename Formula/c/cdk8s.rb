require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.37.tgz"
  sha256 "d8328f2b1075a8bc90d4e766d02664882761d8e21ae0232f9fb37c40001220ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e744bc7ed2e57cb03376896907d04c9c344547eb97e9674960d491625512dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e744bc7ed2e57cb03376896907d04c9c344547eb97e9674960d491625512dc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e744bc7ed2e57cb03376896907d04c9c344547eb97e9674960d491625512dc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e2cd6ebbece3c3cc2cddba2ce652616454213b2be7842e8c25bdef8efb6766c"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2cd6ebbece3c3cc2cddba2ce652616454213b2be7842e8c25bdef8efb6766c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2cd6ebbece3c3cc2cddba2ce652616454213b2be7842e8c25bdef8efb6766c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e744bc7ed2e57cb03376896907d04c9c344547eb97e9674960d491625512dc4"
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