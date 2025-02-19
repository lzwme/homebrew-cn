class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.328.tgz"
  sha256 "f3474217d03f778cad274f0f0e10efef6a562f8e15d54379b9ead43abded8047"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "218e9d151b0ae34fd39c12233e72caccacc422fd4670cd22d6c510ba2f8e1d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "218e9d151b0ae34fd39c12233e72caccacc422fd4670cd22d6c510ba2f8e1d56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "218e9d151b0ae34fd39c12233e72caccacc422fd4670cd22d6c510ba2f8e1d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e464106f335335be2cd9caca765c1c052a159604f12bb029aab3a68b338f22"
    sha256 cellar: :any_skip_relocation, ventura:       "96e464106f335335be2cd9caca765c1c052a159604f12bb029aab3a68b338f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "218e9d151b0ae34fd39c12233e72caccacc422fd4670cd22d6c510ba2f8e1d56"
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