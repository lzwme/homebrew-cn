require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.98.tgz"
  sha256 "958e376c4b0c65c798b9c3278dea006a86623fcd50888f99f4361ee33228eeb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c00607c617c3d1b819a7dcb740f53f211ee70876cb3d9225ef6dcb8b265743b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c00607c617c3d1b819a7dcb740f53f211ee70876cb3d9225ef6dcb8b265743b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c00607c617c3d1b819a7dcb740f53f211ee70876cb3d9225ef6dcb8b265743b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1eaecac29d6b398626fcc4413028a22e86fe18b57e9fd8e5738bbf81238d3d85"
    sha256 cellar: :any_skip_relocation, ventura:        "1eaecac29d6b398626fcc4413028a22e86fe18b57e9fd8e5738bbf81238d3d85"
    sha256 cellar: :any_skip_relocation, monterey:       "1eaecac29d6b398626fcc4413028a22e86fe18b57e9fd8e5738bbf81238d3d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c00607c617c3d1b819a7dcb740f53f211ee70876cb3d9225ef6dcb8b265743b"
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