class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.40.tgz"
  sha256 "c7b4668b6a52d4b447a9e4034ffa0e5c011946d18782700657b6e5c45a878b79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d274aed4f31c74e44de2efe0bc87c9a2417bc8df8e4c8465a89ac8bbe8b8aa07"
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