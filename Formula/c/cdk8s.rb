class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.5.tgz"
  sha256 "fd6ab9252dae37769eac63c33b819ff20eb2edc1d11b2daf934f85e7597f4882"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c9009aefcd0b8f5e9887ca30c680a3ee464889b9f2ce88c7e25aee95cd64d83"
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