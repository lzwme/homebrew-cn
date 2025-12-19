class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.9.tgz"
  sha256 "bad95062099a9d061496489f8cee59ee93e478ad228d32f4e7289b6f690158c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68c443f2b2f1039dc86fa0fa861cc1ae3941c0c61761e4cbb4594dc16aee8ea7"
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