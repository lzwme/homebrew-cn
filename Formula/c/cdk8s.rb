class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.16.tgz"
  sha256 "4500111be26893a77d367d48a6abd7437e718b8c1f12db899b2fbb06107c2591"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c462447c8c5995b46c458dd4850d0180999ac3812edbfb8006bdef653742059"
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