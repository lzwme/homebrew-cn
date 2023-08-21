require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.48.0.tgz"
  sha256 "4a75c810db55b7d0325210f20d23e7af70f030433e5572b24166d7031e55a7df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6d774a1b800500829490b49de13b4477699ee252b268c8d77eba027b3188d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6d774a1b800500829490b49de13b4477699ee252b268c8d77eba027b3188d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6d774a1b800500829490b49de13b4477699ee252b268c8d77eba027b3188d6"
    sha256 cellar: :any_skip_relocation, ventura:        "315aa73f43a76a0efdc43c1b92f5966d6d6582273c5619ca588cbd456ca7832e"
    sha256 cellar: :any_skip_relocation, monterey:       "315aa73f43a76a0efdc43c1b92f5966d6d6582273c5619ca588cbd456ca7832e"
    sha256 cellar: :any_skip_relocation, big_sur:        "315aa73f43a76a0efdc43c1b92f5966d6d6582273c5619ca588cbd456ca7832e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6d774a1b800500829490b49de13b4477699ee252b268c8d77eba027b3188d6"
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