class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.299.tgz"
  sha256 "39b1204794fce88785955425d7b99e38483e28eada59a3e6e329f8f4f78d47cb"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4029e7dcb8357ec151e75765616ec2e64276863e1a1c1398818d4780833e10ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4029e7dcb8357ec151e75765616ec2e64276863e1a1c1398818d4780833e10ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4029e7dcb8357ec151e75765616ec2e64276863e1a1c1398818d4780833e10ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e866ccd586070025285ab97ff9540d5d860e730a9eb3cabba64c11eeace93fe4"
    sha256 cellar: :any_skip_relocation, ventura:       "e866ccd586070025285ab97ff9540d5d860e730a9eb3cabba64c11eeace93fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4029e7dcb8357ec151e75765616ec2e64276863e1a1c1398818d4780833e10ab"
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