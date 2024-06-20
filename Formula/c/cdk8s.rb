require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.150.tgz"
  sha256 "ce9def6cc1c307cbc53317d1ecc50214a547c3b7ee61f2ee6317d16f25c51638"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b492a1ab8f23c08f7b35c99ccdfd8e9f896f2de2d1350aa066d9bf108689d0ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b492a1ab8f23c08f7b35c99ccdfd8e9f896f2de2d1350aa066d9bf108689d0ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b492a1ab8f23c08f7b35c99ccdfd8e9f896f2de2d1350aa066d9bf108689d0ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "b50ef7802f32cc07e7710e3c1a23eb56c9c0a38b920c58688d5cfd60fd6b9fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "b50ef7802f32cc07e7710e3c1a23eb56c9c0a38b920c58688d5cfd60fd6b9fd0"
    sha256 cellar: :any_skip_relocation, monterey:       "b50ef7802f32cc07e7710e3c1a23eb56c9c0a38b920c58688d5cfd60fd6b9fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d509df44e8ea606841664d4a11d9d6e2fd0b0fed97522297708c53c4636a5241"
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