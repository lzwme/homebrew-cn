class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.290.tgz"
  sha256 "9ac5b02fb61f820ede60b80ff285d18725079e7689cc83bc0875033ed0f88caf"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0136b0d628b5fef31184685e9b5b49cacf5f16bc2f935ceb4a8cb9385a4785e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0136b0d628b5fef31184685e9b5b49cacf5f16bc2f935ceb4a8cb9385a4785e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0136b0d628b5fef31184685e9b5b49cacf5f16bc2f935ceb4a8cb9385a4785e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8346b676db240bfcf47d7a79acccb5a4af4d90165d38221431a90f19910da69b"
    sha256 cellar: :any_skip_relocation, ventura:       "8346b676db240bfcf47d7a79acccb5a4af4d90165d38221431a90f19910da69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0136b0d628b5fef31184685e9b5b49cacf5f16bc2f935ceb4a8cb9385a4785e8"
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