class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.37.tgz"
  sha256 "d1bc55f23e3f5fee551e29c3dc7e12956e2807cce64ad4cb9c81edf619c39249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98539163e67d556d4420b302a150dce8dac25222809cd0f200bb53f721ffd941"
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