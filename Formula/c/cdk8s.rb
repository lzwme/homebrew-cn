class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.96.tgz"
  sha256 "0ac426730b782ee9be39d0cf9d206e39a6a24c344f3c5be27fe96be34bb83954"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07760c62140278dce677afc0558eef241e5133cde7f5da5c3de4d8c17bd5cb21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07760c62140278dce677afc0558eef241e5133cde7f5da5c3de4d8c17bd5cb21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07760c62140278dce677afc0558eef241e5133cde7f5da5c3de4d8c17bd5cb21"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ade4846187dde88a92ad2296e247bf3315a2ff79851191e4197059c9cf3804"
    sha256 cellar: :any_skip_relocation, ventura:       "39ade4846187dde88a92ad2296e247bf3315a2ff79851191e4197059c9cf3804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07760c62140278dce677afc0558eef241e5133cde7f5da5c3de4d8c17bd5cb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07760c62140278dce677afc0558eef241e5133cde7f5da5c3de4d8c17bd5cb21"
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