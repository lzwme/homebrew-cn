class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.198.tgz"
  sha256 "a4d36b77f24d513e756ca3da64bc19a6cf14d000c2cdc6559aae1242f15be2c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "561084c4cf0388e002067955ecc612f6f97ff61d12df2c86f43ceda0d53aa137"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "561084c4cf0388e002067955ecc612f6f97ff61d12df2c86f43ceda0d53aa137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "561084c4cf0388e002067955ecc612f6f97ff61d12df2c86f43ceda0d53aa137"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b8e9437fc4f8585ef87889b9a81ac02545ad1a2f02e7b351bb61ebca5b05e04"
    sha256 cellar: :any_skip_relocation, ventura:        "8b8e9437fc4f8585ef87889b9a81ac02545ad1a2f02e7b351bb61ebca5b05e04"
    sha256 cellar: :any_skip_relocation, monterey:       "8b8e9437fc4f8585ef87889b9a81ac02545ad1a2f02e7b351bb61ebca5b05e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561084c4cf0388e002067955ecc612f6f97ff61d12df2c86f43ceda0d53aa137"
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