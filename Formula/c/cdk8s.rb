class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.204.4.tgz"
  sha256 "b9b658eb059a950ebac737ef88099ecee5adc8bb42725f521c0b0bb9378ea5c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "729ae52e38a6f5151072e91e5574d6f6149dd7e82a10c20caf52b92403be50c5"
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