class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.34.tgz"
  sha256 "1c7c8e6e90dd7be1a446298a2ea61ff1a1728511c0f1246ceac5f4a497dc0328"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "821dcf9cf05522030f5f4704b292955976fc7088facafbfc220ebb0846b78724"
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