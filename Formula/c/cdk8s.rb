require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.34.tgz"
  sha256 "16c546dac081188d2890388051cb4c46e59216ca7439c0f84c0115a8c42efb57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59535272509ba4ccc441acbb7e13b03fd584ba9709f3436278c4d120ce7af88f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59535272509ba4ccc441acbb7e13b03fd584ba9709f3436278c4d120ce7af88f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59535272509ba4ccc441acbb7e13b03fd584ba9709f3436278c4d120ce7af88f"
    sha256 cellar: :any_skip_relocation, sonoma:         "57c38853da424a3ba36f6032cdebde193ac71f478c6b83feeec4a44842dcd1c3"
    sha256 cellar: :any_skip_relocation, ventura:        "57c38853da424a3ba36f6032cdebde193ac71f478c6b83feeec4a44842dcd1c3"
    sha256 cellar: :any_skip_relocation, monterey:       "57c38853da424a3ba36f6032cdebde193ac71f478c6b83feeec4a44842dcd1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59535272509ba4ccc441acbb7e13b03fd584ba9709f3436278c4d120ce7af88f"
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