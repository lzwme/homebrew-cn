class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.122.tgz"
  sha256 "7b48dc6659d7dc6d3c089f271038bec6645ac39af76a47b903890296e61bd29f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6d65ddfd63894d213dfc5824315aa421c6b25a70e7d38535abf586ca31f2379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d65ddfd63894d213dfc5824315aa421c6b25a70e7d38535abf586ca31f2379"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6d65ddfd63894d213dfc5824315aa421c6b25a70e7d38535abf586ca31f2379"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a51206c5a65925ba2368e78cf6c96218440523375031dd8fcc6bfcd138566a1"
    sha256 cellar: :any_skip_relocation, ventura:       "1a51206c5a65925ba2368e78cf6c96218440523375031dd8fcc6bfcd138566a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6d65ddfd63894d213dfc5824315aa421c6b25a70e7d38535abf586ca31f2379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d65ddfd63894d213dfc5824315aa421c6b25a70e7d38535abf586ca31f2379"
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