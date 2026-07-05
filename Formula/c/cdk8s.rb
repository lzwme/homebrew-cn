class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.35.tgz"
  sha256 "4c6b9d6a7e554b759e06db58203325d882e7eab87c4e3b24e6d33e7bd3fd7eb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc9540f308d7143405c3e9fb5dd02aef102834c50cb9c33cd03f71792fbbbea5"
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