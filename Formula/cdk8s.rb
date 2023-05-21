require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.38.tgz"
  sha256 "f4dcfacba8b8a574626ddfca05137cb0f21199465bfe9479c897f7a83e98cdc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5fafbf3e3735dd5035eb6d070cf687c5388e4770f029ec87e586cb3150900b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5fafbf3e3735dd5035eb6d070cf687c5388e4770f029ec87e586cb3150900b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb5f4a79fc52decdeb1777ad57fc5ec3e901c3374195d3b2a8e58ad8fa066cc2"
    sha256 cellar: :any_skip_relocation, ventura:        "c357bff2123a181b7bf91c3bba9b89e1271aeedc66d07df26d2880e6c33b049c"
    sha256 cellar: :any_skip_relocation, monterey:       "c357bff2123a181b7bf91c3bba9b89e1271aeedc66d07df26d2880e6c33b049c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c357bff2123a181b7bf91c3bba9b89e1271aeedc66d07df26d2880e6c33b049c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5fafbf3e3735dd5035eb6d070cf687c5388e4770f029ec87e586cb3150900b4"
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