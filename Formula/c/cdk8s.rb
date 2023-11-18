require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.179.0.tgz"
  sha256 "0378de2ddc2c72581f396b233fa1d24e8758aa3250170de1df36f6ae33695ad7"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "634eb1c706a2c04fdbf713b35ea1d5673ac331618d464277d1689c97cc43185f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "634eb1c706a2c04fdbf713b35ea1d5673ac331618d464277d1689c97cc43185f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634eb1c706a2c04fdbf713b35ea1d5673ac331618d464277d1689c97cc43185f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb44844fcb2c2856e749f43789a97958214e7e26e58fe1619c997073f49df439"
    sha256 cellar: :any_skip_relocation, ventura:        "cb44844fcb2c2856e749f43789a97958214e7e26e58fe1619c997073f49df439"
    sha256 cellar: :any_skip_relocation, monterey:       "cb44844fcb2c2856e749f43789a97958214e7e26e58fe1619c997073f49df439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634eb1c706a2c04fdbf713b35ea1d5673ac331618d464277d1689c97cc43185f"
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