class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.114.tgz"
  sha256 "ef038b2d2800e257a6c4c5056ba5be061a748ee63c1cbe6d5c2c95b6410d8d12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ae869bb0cb54a398097038939938fa3a4138907e1652867921379d6e0a9298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ae869bb0cb54a398097038939938fa3a4138907e1652867921379d6e0a9298"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48ae869bb0cb54a398097038939938fa3a4138907e1652867921379d6e0a9298"
    sha256 cellar: :any_skip_relocation, sonoma:        "546f263f59d3830c9d75fd411edf062d39d216d9e4ad63fd87fc7d0bfaedc2fe"
    sha256 cellar: :any_skip_relocation, ventura:       "546f263f59d3830c9d75fd411edf062d39d216d9e4ad63fd87fc7d0bfaedc2fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48ae869bb0cb54a398097038939938fa3a4138907e1652867921379d6e0a9298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ae869bb0cb54a398097038939938fa3a4138907e1652867921379d6e0a9298"
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