require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.141.tgz"
  sha256 "1c313f78107df4228b812b8f18694d189f0d4625dd46e1d309eba34fe6944afe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dcde87f8a41faca2f626da24807ffa1bcb53765229527c9d789648308f3f8c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcde87f8a41faca2f626da24807ffa1bcb53765229527c9d789648308f3f8c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dcde87f8a41faca2f626da24807ffa1bcb53765229527c9d789648308f3f8c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "82e57ad02e642c7b01d78dcda8d33ccadee3dcf89e391b1429a41a0f19552b89"
    sha256 cellar: :any_skip_relocation, ventura:        "82e57ad02e642c7b01d78dcda8d33ccadee3dcf89e391b1429a41a0f19552b89"
    sha256 cellar: :any_skip_relocation, monterey:       "82e57ad02e642c7b01d78dcda8d33ccadee3dcf89e391b1429a41a0f19552b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c8896b343f35690865610bc6fa048fe14d4b3c812d250a3ee87355c83e4bfc"
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