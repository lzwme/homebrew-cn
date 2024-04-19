require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.103.tgz"
  sha256 "04ccebc994b7f7ddb1b09e53ba51ddcf20480d343a119453f166f410a6386f70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e508a1bb73311f087870c902e2470b06f6ec5cbfa7081914e7eb67c5bc1aa496"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e508a1bb73311f087870c902e2470b06f6ec5cbfa7081914e7eb67c5bc1aa496"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e508a1bb73311f087870c902e2470b06f6ec5cbfa7081914e7eb67c5bc1aa496"
    sha256 cellar: :any_skip_relocation, sonoma:         "32e82344e005b3cd495badbe95452ae86ecdb6c3b18621a06434801376c9607e"
    sha256 cellar: :any_skip_relocation, ventura:        "32e82344e005b3cd495badbe95452ae86ecdb6c3b18621a06434801376c9607e"
    sha256 cellar: :any_skip_relocation, monterey:       "32e82344e005b3cd495badbe95452ae86ecdb6c3b18621a06434801376c9607e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e508a1bb73311f087870c902e2470b06f6ec5cbfa7081914e7eb67c5bc1aa496"
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