class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.184.tgz"
  sha256 "8f915405e8f0549a44119abcda5aef9a5542230b05bbccc7332b5773f784e705"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52374759a914b9d26bf91aebb974cdc94dba7d97a6048ee7051e4e6c550f6fbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52374759a914b9d26bf91aebb974cdc94dba7d97a6048ee7051e4e6c550f6fbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52374759a914b9d26bf91aebb974cdc94dba7d97a6048ee7051e4e6c550f6fbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "44e8ab41e644aa328593a164f8b4bfee7e1dda020c9aed741ed024d77125cbfc"
    sha256 cellar: :any_skip_relocation, ventura:        "44e8ab41e644aa328593a164f8b4bfee7e1dda020c9aed741ed024d77125cbfc"
    sha256 cellar: :any_skip_relocation, monterey:       "44e8ab41e644aa328593a164f8b4bfee7e1dda020c9aed741ed024d77125cbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52374759a914b9d26bf91aebb974cdc94dba7d97a6048ee7051e4e6c550f6fbe"
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