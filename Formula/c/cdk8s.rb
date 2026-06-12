class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.20.tgz"
  sha256 "38de7d41eed58f7be73a3cd63feda06c2068eb8ac0c844a0352782d02ddc8e3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94cf30e62626234b5e0f281fea8efc83434a9459cbdddb12eea100351c58282b"
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