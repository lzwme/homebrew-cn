class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.7.tgz"
  sha256 "e7c8dad40d53bbc3a059f18df61f1b39bf9849c9be8263944f5edcafd2b6d68e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37fa546ce9d25c42ae88cc62ab9cefad393b332c77882cb02ae744e58eeab9df"
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