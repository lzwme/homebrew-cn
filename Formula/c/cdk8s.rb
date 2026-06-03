class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.12.tgz"
  sha256 "6040053be72616d172f917910ed86c043652add3c9b0fa6879ee9ad259ad0905"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f14f8677d01b3136afa317474fccbd0cd4dd961ff753632cd4de12c047d95cff"
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