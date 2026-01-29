class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.3.tgz"
  sha256 "476e71ae5341322b7c0232eb8257b3b03f23b9840641cab99b7f93134af7870a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23656cdb9636b7a0445bd80ae0af17830e0684bacd59f5fe36b4531b7acd45f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end