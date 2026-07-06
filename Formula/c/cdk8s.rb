class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.36.tgz"
  sha256 "2d5cf0dece4b6001455c1a9703a4e86099b71ec1f13608fc45cbd7608f056607"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9afe20784a41bbd01045bfaa54d9656822f29f9e811be8e28ce3daace716f8b8"
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