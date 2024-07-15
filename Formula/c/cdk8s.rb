require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.172.tgz"
  sha256 "39c1762923ee2ffb96f13e14674e1b3b7c8f240d7fbf4a63d6b4b705f95ed194"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a9f1f4b411baff95c94b7192505819b066cebacd69bbaad99d4dbd851b66fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66a9f1f4b411baff95c94b7192505819b066cebacd69bbaad99d4dbd851b66fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66a9f1f4b411baff95c94b7192505819b066cebacd69bbaad99d4dbd851b66fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "91d090c9f19eb0aca54f712e141aa41dead3d0f7eaa32f349c345f9d3598517f"
    sha256 cellar: :any_skip_relocation, ventura:        "91d090c9f19eb0aca54f712e141aa41dead3d0f7eaa32f349c345f9d3598517f"
    sha256 cellar: :any_skip_relocation, monterey:       "91d090c9f19eb0aca54f712e141aa41dead3d0f7eaa32f349c345f9d3598517f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cda8383204b2245a8e48e2fb0d61aaf3f783c9b889fcf35d3513f10a298576a"
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