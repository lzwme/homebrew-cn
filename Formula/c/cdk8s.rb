class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.49.tgz"
  sha256 "45664391b0c30718c2d64a867adf6a54569127e5ddb9b2c5525bfa84270da41d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43d2c2f7ef4391ecc3f81e653a5910f29f897d6ea5564d716b670cf4c7ba54cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end