class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.279.tgz"
  sha256 "aed32a11f6676985fde1199c8419ca01645106980abf6b5681dae744d607ad03"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eef910c88f7bc008785aee192eb1459a0d6c013dc2cf29b5d9b15b0350f8320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eef910c88f7bc008785aee192eb1459a0d6c013dc2cf29b5d9b15b0350f8320"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eef910c88f7bc008785aee192eb1459a0d6c013dc2cf29b5d9b15b0350f8320"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cabcb4e1166db881f92f2f240bf843697371525ef68f2e2f1228b18015dfd15"
    sha256 cellar: :any_skip_relocation, ventura:       "6cabcb4e1166db881f92f2f240bf843697371525ef68f2e2f1228b18015dfd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eef910c88f7bc008785aee192eb1459a0d6c013dc2cf29b5d9b15b0350f8320"
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