require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.167.0.tgz"
  sha256 "c0d85c4a2c4934adda581690dd1f779c7c54324c17f87acbb0ebf8e4e396f333"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c6d0561151f7b0818cad098a408e05b0bf0a9c2aa4253a77582015c0cc3d631"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c6d0561151f7b0818cad098a408e05b0bf0a9c2aa4253a77582015c0cc3d631"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c6d0561151f7b0818cad098a408e05b0bf0a9c2aa4253a77582015c0cc3d631"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fc68d202ec51e4fa02ef59bbb23afc5b626c30fbc4e426fdba3417499b657ea"
    sha256 cellar: :any_skip_relocation, ventura:        "7fc68d202ec51e4fa02ef59bbb23afc5b626c30fbc4e426fdba3417499b657ea"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc68d202ec51e4fa02ef59bbb23afc5b626c30fbc4e426fdba3417499b657ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6d0561151f7b0818cad098a408e05b0bf0a9c2aa4253a77582015c0cc3d631"
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