require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.162.0.tgz"
  sha256 "8299fe36f22040b43b3c4d99689a2db99339dde99db0be7a6c626d9d9acdf652"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae4c1311a8adb3cfde2caca56f5594cf9b42b242caa3464c71c657fa9c02fe1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae4c1311a8adb3cfde2caca56f5594cf9b42b242caa3464c71c657fa9c02fe1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae4c1311a8adb3cfde2caca56f5594cf9b42b242caa3464c71c657fa9c02fe1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "72606c6dc68b46437ca7898a9d3dc39f8b27a02762464503545bed8767a21a78"
    sha256 cellar: :any_skip_relocation, ventura:        "72606c6dc68b46437ca7898a9d3dc39f8b27a02762464503545bed8767a21a78"
    sha256 cellar: :any_skip_relocation, monterey:       "72606c6dc68b46437ca7898a9d3dc39f8b27a02762464503545bed8767a21a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4c1311a8adb3cfde2caca56f5594cf9b42b242caa3464c71c657fa9c02fe1b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end