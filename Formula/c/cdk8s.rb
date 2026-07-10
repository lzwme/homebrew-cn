class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.39.tgz"
  sha256 "901afa0f25f38d2ba089565c81354d90c54fc66262e26659d81aa22823e3f220"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc8eb48e0d719b95965198a9600f2d2d8dc17e4814ab1e3e05c8bac16a32b781"
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