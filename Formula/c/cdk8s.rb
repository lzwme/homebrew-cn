class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.69.tgz"
  sha256 "74c9d1398b2468a8d0416832f24665c5f9944c408d74cfaab9079bfa45b2a1b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc9b769e50030cebb8f56eb682bbaca53efe9f7797c56e303a9b7278cd76f28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdc9b769e50030cebb8f56eb682bbaca53efe9f7797c56e303a9b7278cd76f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdc9b769e50030cebb8f56eb682bbaca53efe9f7797c56e303a9b7278cd76f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b9155fe936fe5e213588fba8ae763ec8e2d65e4471faa64e26cd50c53780c1"
    sha256 cellar: :any_skip_relocation, ventura:       "68b9155fe936fe5e213588fba8ae763ec8e2d65e4471faa64e26cd50c53780c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc9b769e50030cebb8f56eb682bbaca53efe9f7797c56e303a9b7278cd76f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc9b769e50030cebb8f56eb682bbaca53efe9f7797c56e303a9b7278cd76f28"
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