class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.12.tgz"
  sha256 "d8a241c2aafd6698e636c155bf595dc495a8229fd8a4fa150260413a6dd8b63f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e9d305aabc9ad3950988b6c2e7a4e2d57a593066b8354036f25003905fd902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e9d305aabc9ad3950988b6c2e7a4e2d57a593066b8354036f25003905fd902"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84e9d305aabc9ad3950988b6c2e7a4e2d57a593066b8354036f25003905fd902"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cde1384180a40d0c68ebfb8364b72a951e045a44825ce4d0c9fa3acb648923"
    sha256 cellar: :any_skip_relocation, ventura:       "21cde1384180a40d0c68ebfb8364b72a951e045a44825ce4d0c9fa3acb648923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e9d305aabc9ad3950988b6c2e7a4e2d57a593066b8354036f25003905fd902"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end