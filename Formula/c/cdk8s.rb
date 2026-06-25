class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.28.tgz"
  sha256 "2dfa9055ca559dac5bbce36e771f36624154f1fa4e4f17f954fa68613e260d4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80a7c81ab4202c59047f06f45ba6cee1613d5f7c9df86ee44aeae0172f2cc8aa"
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