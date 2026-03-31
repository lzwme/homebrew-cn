class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.205.5.tgz"
  sha256 "75f26cfe5f560a365a09fd19a7ad7cb6d58b88e9fd490672ed8e0a42f4be108f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c7d1a5f89001eb5594d51ff4daa368fdac60bd0a1c4abf257d009578b426c4d"
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