class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.32.tgz"
  sha256 "bdae3125f380bbb7f5744aa19b5c75494eac7a4797591c316805c106d565d720"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "401e0dededd582b4c971d974468ce29d5d4bc88f136d0673bf7d38d0322af747"
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