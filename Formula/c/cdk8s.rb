class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.19.tgz"
  sha256 "ec12e5890a4fd48b0af0ec2c05a500c061171010735c9b05f679d954e8a7a590"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b946d006364e423264c6b58f9ea7ec9671f3849f80d54b12bba5d1feea51b4c"
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