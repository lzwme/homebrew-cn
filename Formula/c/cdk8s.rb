class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.131.tgz"
  sha256 "53dad5c53a674fb75f8cd4de6ceddfd56eb728dd51496a1c186a53c77b8337f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5539f93915ed67f3f952ffa9293a8f7819fc6be7d51bb47e969d8a33fae8b00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5539f93915ed67f3f952ffa9293a8f7819fc6be7d51bb47e969d8a33fae8b00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5539f93915ed67f3f952ffa9293a8f7819fc6be7d51bb47e969d8a33fae8b00f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6828654794d2a066c4262408ac7cb914696f234595b7df18089170a78eb27755"
    sha256 cellar: :any_skip_relocation, ventura:       "6828654794d2a066c4262408ac7cb914696f234595b7df18089170a78eb27755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5539f93915ed67f3f952ffa9293a8f7819fc6be7d51bb47e969d8a33fae8b00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5539f93915ed67f3f952ffa9293a8f7819fc6be7d51bb47e969d8a33fae8b00f"
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