require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.120.tgz"
  sha256 "ec447df346c57a54dff5ccbc96d07ba04715ea20e1356dd84bc6d1a6ee470eeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be21c1c0a43f0755a769d1d16ad8f6283821df05e370dc1b161cce0dd6cf7424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cdcb19c0e734717a04add7627ab5538a289094303f41408d787121a6f06d516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f57fe082d090f648139d8a56564037dce9d4b2a7d4019db779ef6763c1c456e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad7c9c7e44af3b1832477685b18f549f4c3ee24f8a2b8d1bf73d48cd153dc146"
    sha256 cellar: :any_skip_relocation, ventura:        "590dd4f53710d268bb83ebe0629d14a53a6d909057485c2e4a5334b579abb69c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7508c1a170a7e9575046d15edd160c5e2f2d673e2e26d43ddf14339e794f5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177907f030e3993d0ec2cd1018a89b171245929b1fda42154343775788e393c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end