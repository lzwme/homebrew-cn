require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.41.tgz"
  sha256 "2c66a3f4a0c363f1c3e231b81d707c0c478b236519d34f22dfc7f5f6a0512e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "821f1a09e509d6452528c78611da1e51f65904f5af3dacddda37c2b37c305925"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "821f1a09e509d6452528c78611da1e51f65904f5af3dacddda37c2b37c305925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821f1a09e509d6452528c78611da1e51f65904f5af3dacddda37c2b37c305925"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0fff43aa312315c39bb1f6afac26801ab6fee05f893a925e60ef2ac6e0d1b9f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0fff43aa312315c39bb1f6afac26801ab6fee05f893a925e60ef2ac6e0d1b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "c0fff43aa312315c39bb1f6afac26801ab6fee05f893a925e60ef2ac6e0d1b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821f1a09e509d6452528c78611da1e51f65904f5af3dacddda37c2b37c305925"
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