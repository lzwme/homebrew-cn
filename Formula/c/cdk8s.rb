require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.113.tgz"
  sha256 "0ccc0aec959735dda21035d96e64daea9fba725d32002ae269d0d8ad0b1e6c09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a0652010bb6eac5aabef0ab9973b3adb428c17ee6654815667b6325b097d5c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7624f44cde1f00204f72cf82c933386d240b2649095927b91348127456c5c9bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b46bd8553577b356e95a5a496b20a92a5104ea08dd2ce9aa82a1d0429261904"
    sha256 cellar: :any_skip_relocation, sonoma:         "78f7528d96bdd6f84ecca2bf615a0c1e7abf210afae3347a856b6d4184af9f1c"
    sha256 cellar: :any_skip_relocation, ventura:        "429172a366776d093fd4ec2bd76cb8ab1304cb8d7bd81e114e274079a914dc74"
    sha256 cellar: :any_skip_relocation, monterey:       "139d64c8421f8d21b054c28041f193ffebb4d90b88af1fa02731451a999ea75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b934ab998bb2cb3f2e3ab908e87ea403cee5cc4061113a5f9e67fe5f5b31c5e5"
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