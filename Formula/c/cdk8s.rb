class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.7.tgz"
  sha256 "c6c47d638aea3973d1ac54bc101260158bb60ecac26352fed7a8d76bc78f25a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ecf9eaeb2ead0a9d85815aa112edbb9a74024026b732a9b0b369b5e6b1fde2d"
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