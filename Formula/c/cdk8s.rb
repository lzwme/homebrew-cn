class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.10.tgz"
  sha256 "9d58efcb745a0759b9199a8388894ea9b626d584090658c87add89a8d85e47bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8b7509c98efc4acb77c7bd3148960129272e0ba98a144839433b40552122385"
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