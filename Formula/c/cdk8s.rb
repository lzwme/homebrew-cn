class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.207.tgz"
  sha256 "256a4da9902ae6487552444433503e3fd5950bcfa6edcb3b6127d177afc15c33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19489abec0b2d8d9cdebe6573bd81a995a3de230503bb01800263896a501d92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f19489abec0b2d8d9cdebe6573bd81a995a3de230503bb01800263896a501d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19489abec0b2d8d9cdebe6573bd81a995a3de230503bb01800263896a501d92"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e8d8f60e61b87cadfe2fa2bfef7a973c3b055ab77202fae72c575129cbe68e0"
    sha256 cellar: :any_skip_relocation, ventura:        "7e8d8f60e61b87cadfe2fa2bfef7a973c3b055ab77202fae72c575129cbe68e0"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8d8f60e61b87cadfe2fa2bfef7a973c3b055ab77202fae72c575129cbe68e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19489abec0b2d8d9cdebe6573bd81a995a3de230503bb01800263896a501d92"
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