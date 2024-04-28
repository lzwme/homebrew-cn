require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.106.tgz"
  sha256 "b1c97e6b9bc635829b5aeb462ea8928df3d65b30756250c24cf86142da3dc389"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4d4248072b66ddfe317570a20e5d3697992908a3843b27272b05220e96d6b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d4248072b66ddfe317570a20e5d3697992908a3843b27272b05220e96d6b9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d4248072b66ddfe317570a20e5d3697992908a3843b27272b05220e96d6b9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5e53404795202e1e62c514ee15eea8637d4371a5061792e8027f19473b6a06f"
    sha256 cellar: :any_skip_relocation, ventura:        "c5e53404795202e1e62c514ee15eea8637d4371a5061792e8027f19473b6a06f"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e53404795202e1e62c514ee15eea8637d4371a5061792e8027f19473b6a06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4d4248072b66ddfe317570a20e5d3697992908a3843b27272b05220e96d6b9c"
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