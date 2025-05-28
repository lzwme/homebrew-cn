class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.82.tgz"
  sha256 "07a7c8c85a714c5a07661e7e017664b9d0560bebce6fdd900af2fa4444a53e2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ecc11e7701e2b9b4ebc91b6efcc80f5979a78d5b8b996b1751aa78cab0bc4fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ecc11e7701e2b9b4ebc91b6efcc80f5979a78d5b8b996b1751aa78cab0bc4fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ecc11e7701e2b9b4ebc91b6efcc80f5979a78d5b8b996b1751aa78cab0bc4fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a24083a79bc486315e7372beb1dfa43f1281fbd0846d34bf9414694cbffccc07"
    sha256 cellar: :any_skip_relocation, ventura:       "a24083a79bc486315e7372beb1dfa43f1281fbd0846d34bf9414694cbffccc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ecc11e7701e2b9b4ebc91b6efcc80f5979a78d5b8b996b1751aa78cab0bc4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecc11e7701e2b9b4ebc91b6efcc80f5979a78d5b8b996b1751aa78cab0bc4fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end