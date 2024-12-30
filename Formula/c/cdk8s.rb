class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.291.tgz"
  sha256 "16c33a31f99d35dadc0d3a4f54cf71f703cf17fd0470ade612287a327ba2f2f5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1718fa20459e3c6dec6c02cd414bff6a6a77211845c4fb624c8fcb04162547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1718fa20459e3c6dec6c02cd414bff6a6a77211845c4fb624c8fcb04162547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c1718fa20459e3c6dec6c02cd414bff6a6a77211845c4fb624c8fcb04162547"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cdddbb7f467f7ddb7748f621dc4e17a187bc3025d298aad1f75b6ce0024a71f"
    sha256 cellar: :any_skip_relocation, ventura:       "5cdddbb7f467f7ddb7748f621dc4e17a187bc3025d298aad1f75b6ce0024a71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1718fa20459e3c6dec6c02cd414bff6a6a77211845c4fb624c8fcb04162547"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end