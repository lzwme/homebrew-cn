class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.72.tgz"
  sha256 "b23b29f5b9c38e4535dbfa9ae40b3bdb4287d61bcad1a8112340aa4ed1ef80f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ccb1d785d06b5d268681ec7ab158c24d2e7741cc1c7f1be0dad2e8bb8b77a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92ccb1d785d06b5d268681ec7ab158c24d2e7741cc1c7f1be0dad2e8bb8b77a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92ccb1d785d06b5d268681ec7ab158c24d2e7741cc1c7f1be0dad2e8bb8b77a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b896f35723502e294fa2c53a6fb9754fc7ffd12140d2d59032281618eb2ea37a"
    sha256 cellar: :any_skip_relocation, ventura:       "b896f35723502e294fa2c53a6fb9754fc7ffd12140d2d59032281618eb2ea37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ccb1d785d06b5d268681ec7ab158c24d2e7741cc1c7f1be0dad2e8bb8b77a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92ccb1d785d06b5d268681ec7ab158c24d2e7741cc1c7f1be0dad2e8bb8b77a4"
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