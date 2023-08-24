require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.54.0.tgz"
  sha256 "d608b6ef8c1db43703e6ccf1e0315e746ed33d973bd288b8e8572b652378c286"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0faf4b58334eec639f9af3a19321adbd70ab25bcaa7f4f8ef2fad720cf3a843f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0faf4b58334eec639f9af3a19321adbd70ab25bcaa7f4f8ef2fad720cf3a843f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0faf4b58334eec639f9af3a19321adbd70ab25bcaa7f4f8ef2fad720cf3a843f"
    sha256 cellar: :any_skip_relocation, ventura:        "27c23231dbb9a646a74a1c393662c670d98b97768b8e4936843c4c8df639a48b"
    sha256 cellar: :any_skip_relocation, monterey:       "27c23231dbb9a646a74a1c393662c670d98b97768b8e4936843c4c8df639a48b"
    sha256 cellar: :any_skip_relocation, big_sur:        "27c23231dbb9a646a74a1c393662c670d98b97768b8e4936843c4c8df639a48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0faf4b58334eec639f9af3a19321adbd70ab25bcaa7f4f8ef2fad720cf3a843f"
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