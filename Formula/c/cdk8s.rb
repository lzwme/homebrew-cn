class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.272.tgz"
  sha256 "0a361dd0bf4fe7e0b90f1773fc2cf86e90ede69169838842fc44321e70ec7691"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "923c9b74cdcb0d961bbf72cb2c8a9c681f49ea78ad9d132e9ccef44779a8056a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "923c9b74cdcb0d961bbf72cb2c8a9c681f49ea78ad9d132e9ccef44779a8056a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "923c9b74cdcb0d961bbf72cb2c8a9c681f49ea78ad9d132e9ccef44779a8056a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c80449345ef1991f61ccc2c2b174eed26dce52847d3fb41c506794d102e53ba9"
    sha256 cellar: :any_skip_relocation, ventura:       "c80449345ef1991f61ccc2c2b174eed26dce52847d3fb41c506794d102e53ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923c9b74cdcb0d961bbf72cb2c8a9c681f49ea78ad9d132e9ccef44779a8056a"
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