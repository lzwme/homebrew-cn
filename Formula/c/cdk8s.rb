class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.186.tgz"
  sha256 "2805581a302ce7b9e858648323fcfab0550fa2f0b9db1a1711fd2dcac77b27ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd29447f509d8617dd2fffe55385290496d71dec0d28a99a414dbf5fada85c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd29447f509d8617dd2fffe55385290496d71dec0d28a99a414dbf5fada85c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd29447f509d8617dd2fffe55385290496d71dec0d28a99a414dbf5fada85c79"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc9fcc12752a00bcb72fb483c496b56602ae991464db836ebdc02009855e8149"
    sha256 cellar: :any_skip_relocation, ventura:        "bc9fcc12752a00bcb72fb483c496b56602ae991464db836ebdc02009855e8149"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9fcc12752a00bcb72fb483c496b56602ae991464db836ebdc02009855e8149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd29447f509d8617dd2fffe55385290496d71dec0d28a99a414dbf5fada85c79"
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