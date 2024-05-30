require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.132.tgz"
  sha256 "3f161774f34150281380ba58fe1e1dbd607781be6c5a5ce334511b9a12f40728"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "946dbe6d636d33c630b6edd26ce63705e434ad6aa4c1b046bf43705fdeafca9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "946dbe6d636d33c630b6edd26ce63705e434ad6aa4c1b046bf43705fdeafca9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "946dbe6d636d33c630b6edd26ce63705e434ad6aa4c1b046bf43705fdeafca9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4983e4cd84d4eebe2305c0f49bad490d33b48cbf2936413da5c420457453a661"
    sha256 cellar: :any_skip_relocation, ventura:        "4983e4cd84d4eebe2305c0f49bad490d33b48cbf2936413da5c420457453a661"
    sha256 cellar: :any_skip_relocation, monterey:       "4983e4cd84d4eebe2305c0f49bad490d33b48cbf2936413da5c420457453a661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab00900458b8ac478fdb72a2af55aa4390a0c829fc57691ea291dc80c7dd05c"
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