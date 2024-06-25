require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.154.tgz"
  sha256 "c5b5fd803986b37dfcaca1caaf0286fd0bae7fd2f802296abc685186db667313"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09764dcaa4ce63e6f3965e100f240a071ecd59ff920a238e90fe9ce02220005e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09764dcaa4ce63e6f3965e100f240a071ecd59ff920a238e90fe9ce02220005e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09764dcaa4ce63e6f3965e100f240a071ecd59ff920a238e90fe9ce02220005e"
    sha256 cellar: :any_skip_relocation, sonoma:         "867fcc15b6c3e7e6924dc115c250f7f7fefd18a0f7b672dc069f1ea6b02a16bb"
    sha256 cellar: :any_skip_relocation, ventura:        "867fcc15b6c3e7e6924dc115c250f7f7fefd18a0f7b672dc069f1ea6b02a16bb"
    sha256 cellar: :any_skip_relocation, monterey:       "867fcc15b6c3e7e6924dc115c250f7f7fefd18a0f7b672dc069f1ea6b02a16bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e331210c9c310a480d5b973850eaa731fcaf31aad54d78b25a06c76339e49d1d"
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