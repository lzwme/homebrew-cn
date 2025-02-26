class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.0.tgz"
  sha256 "be86648becda749b7f276b5edca85be5b781f6d46b00c082fd01f4bc99c8c6d5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd8d4914450a9f6eb387663f4e9dc83c0e607f321380f73fe8405dd6639bbeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bd8d4914450a9f6eb387663f4e9dc83c0e607f321380f73fe8405dd6639bbeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bd8d4914450a9f6eb387663f4e9dc83c0e607f321380f73fe8405dd6639bbeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "77624758f34479b90a3fa755f9ccd6784884fc835e5cfe8ae7df33965acd70e0"
    sha256 cellar: :any_skip_relocation, ventura:       "77624758f34479b90a3fa755f9ccd6784884fc835e5cfe8ae7df33965acd70e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c3dbe24e8fd75ba967c8127e9a400106469cc2af9e2409a44be4a56b5d57cc"
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