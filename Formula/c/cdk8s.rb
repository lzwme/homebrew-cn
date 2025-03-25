class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.27.tgz"
  sha256 "18963be645b719b6258fe5570e2139615ad4ab04208f4edd9e5a4037940ec26f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55286414af185c41f1669aa012664d7cd6e75dd2e26b16ad821c8468b2371406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55286414af185c41f1669aa012664d7cd6e75dd2e26b16ad821c8468b2371406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55286414af185c41f1669aa012664d7cd6e75dd2e26b16ad821c8468b2371406"
    sha256 cellar: :any_skip_relocation, sonoma:        "5440e0eccd5d1ebf1129aa724bba601a187825add1c0649130fad3ac9696b143"
    sha256 cellar: :any_skip_relocation, ventura:       "5440e0eccd5d1ebf1129aa724bba601a187825add1c0649130fad3ac9696b143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55286414af185c41f1669aa012664d7cd6e75dd2e26b16ad821c8468b2371406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55286414af185c41f1669aa012664d7cd6e75dd2e26b16ad821c8468b2371406"
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