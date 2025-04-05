class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.33.tgz"
  sha256 "7ee17148c0c9de37b8f015f3e5672c25495a3c9f60b70c9bbbb68ed4eb65f4d3"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbaa6a3acd76ac0595d024c2fb10593ef1423ff7d71d6b201db10d69566468c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbaa6a3acd76ac0595d024c2fb10593ef1423ff7d71d6b201db10d69566468c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbaa6a3acd76ac0595d024c2fb10593ef1423ff7d71d6b201db10d69566468c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "085f3db097e23e67edec39b02426b281fcdad4688e9ea889ac67fd5a8c668894"
    sha256 cellar: :any_skip_relocation, ventura:       "085f3db097e23e67edec39b02426b281fcdad4688e9ea889ac67fd5a8c668894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbaa6a3acd76ac0595d024c2fb10593ef1423ff7d71d6b201db10d69566468c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbaa6a3acd76ac0595d024c2fb10593ef1423ff7d71d6b201db10d69566468c6"
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