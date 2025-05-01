class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.56.tgz"
  sha256 "611a15853ba55705fc343eae353a15fc9d73adabec9877a756c66ad1786f6402"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61fd3453558ab1332d00aa684747eb8e6b46c41b19873b22cca5c46a1918b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b61fd3453558ab1332d00aa684747eb8e6b46c41b19873b22cca5c46a1918b92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b61fd3453558ab1332d00aa684747eb8e6b46c41b19873b22cca5c46a1918b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b0c20f686d9dd0c7d3a788e9973c03e220210eb706da7174ec3776cfdb89c4"
    sha256 cellar: :any_skip_relocation, ventura:       "98b0c20f686d9dd0c7d3a788e9973c03e220210eb706da7174ec3776cfdb89c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b61fd3453558ab1332d00aa684747eb8e6b46c41b19873b22cca5c46a1918b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61fd3453558ab1332d00aa684747eb8e6b46c41b19873b22cca5c46a1918b92"
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