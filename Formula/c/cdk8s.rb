class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.31.tgz"
  sha256 "9eb1cf29c62f7d7a9a3c8c9953c7b0a1bbc16121f990cdee1816c69f18a203ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53a36ff0aa534ecba2e10bc5eb97a2ad9ba4bc347856acf18cd64f8206e93775"
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