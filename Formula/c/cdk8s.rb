class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.80.tgz"
  sha256 "099b456ab552b352a24f7c942ecb9039768a147c83718f4e8268ed44534efc71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b831483cb229e175d34ded2f90b3b471d97a899fa05f87d51acfe9b0f2eee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b831483cb229e175d34ded2f90b3b471d97a899fa05f87d51acfe9b0f2eee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48b831483cb229e175d34ded2f90b3b471d97a899fa05f87d51acfe9b0f2eee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2e0391f926ea2f6202025c09593e2ebfe115d306eb017e1500997ba9f13949"
    sha256 cellar: :any_skip_relocation, ventura:       "5a2e0391f926ea2f6202025c09593e2ebfe115d306eb017e1500997ba9f13949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b831483cb229e175d34ded2f90b3b471d97a899fa05f87d51acfe9b0f2eee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b831483cb229e175d34ded2f90b3b471d97a899fa05f87d51acfe9b0f2eee8"
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