class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.62.tgz"
  sha256 "ed2d8b064128d22340ae2281c72b606dd64cd61ecfab60b0a71ceba4bf3aee84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30b63700b9d546dae8404624148f748bc82b43568e322961de6f640163d1dd36"
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