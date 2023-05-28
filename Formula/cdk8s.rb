require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.44.tgz"
  sha256 "d12263dd0c38032f698d736c7cd3ba86432c740dfed0357a80f756841623f55b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738859f1bb26f6eba6addff3b96c2eebbccea55f1c2f0d391a5c59ae9a7e8f6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "738859f1bb26f6eba6addff3b96c2eebbccea55f1c2f0d391a5c59ae9a7e8f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "738859f1bb26f6eba6addff3b96c2eebbccea55f1c2f0d391a5c59ae9a7e8f6d"
    sha256 cellar: :any_skip_relocation, ventura:        "3cc44160127ebe1a55d9d844a72f857faed1d123514d8a0248e954ae00129c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc44160127ebe1a55d9d844a72f857faed1d123514d8a0248e954ae00129c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cc44160127ebe1a55d9d844a72f857faed1d123514d8a0248e954ae00129c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "738859f1bb26f6eba6addff3b96c2eebbccea55f1c2f0d391a5c59ae9a7e8f6d"
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