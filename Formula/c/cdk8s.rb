class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.47.tgz"
  sha256 "22fe47c23c53325c7b8e048e94e6aadb049d977ee9c10f4ce6f45fbb395982fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dcbb8f46fca5b75685750a83dd45bd2f0bc886a4d28cce5eaefbe32970ddcc6c"
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