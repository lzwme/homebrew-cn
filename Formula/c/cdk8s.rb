require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.165.tgz"
  sha256 "d2232b8c79b6391d81be9bdb4482d6d4f5ca9947c79ac181aaf05b9cca63e52e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "818b86540387fafefa4ef937f6b5cfaf92b907864ab4d7b8656ca03606558c4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "818b86540387fafefa4ef937f6b5cfaf92b907864ab4d7b8656ca03606558c4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818b86540387fafefa4ef937f6b5cfaf92b907864ab4d7b8656ca03606558c4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ba71bcf07d721c4fbd5efa39285a308a0fd172a99309dab6dd93c7e300f788d"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba71bcf07d721c4fbd5efa39285a308a0fd172a99309dab6dd93c7e300f788d"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba71bcf07d721c4fbd5efa39285a308a0fd172a99309dab6dd93c7e300f788d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782219488d2f58bc69fad7f5752533ad1d8e4704f71fe8f974aab0c6d4eba961"
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