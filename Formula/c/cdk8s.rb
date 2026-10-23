class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.70.tgz"
  sha256 "4773391feebfa05bfb80cd0ec210cc8ac06527bf6cc43601e413a32342a8cba1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a62047060585b620ca8ef85166e555062cc982f00b52d1e62ccf400e74394cb7"
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