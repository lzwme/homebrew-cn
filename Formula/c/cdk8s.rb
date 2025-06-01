class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.86.tgz"
  sha256 "64ef50efa493e4aa871066854a0ad7d200aa995f217b4f664439bd49193ddbcd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b669d35f5d85b611b31d387231159ea5f71aa8a642ac422e67d823315d7a5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b669d35f5d85b611b31d387231159ea5f71aa8a642ac422e67d823315d7a5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23b669d35f5d85b611b31d387231159ea5f71aa8a642ac422e67d823315d7a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a68f233e8b3ae43d154b058c95b970a91899706a7b67159fd9c3e7bc89b61ee"
    sha256 cellar: :any_skip_relocation, ventura:       "3a68f233e8b3ae43d154b058c95b970a91899706a7b67159fd9c3e7bc89b61ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b669d35f5d85b611b31d387231159ea5f71aa8a642ac422e67d823315d7a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b669d35f5d85b611b31d387231159ea5f71aa8a642ac422e67d823315d7a5e"
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