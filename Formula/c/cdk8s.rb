require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.187.0.tgz"
  sha256 "645369653240912d9f95893c3a7f7c2358a35765144cc15a6b7c9553779bc371"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0653b61b23eaa8308e30d42f5b273bffad3e4ce0c5a7704e571b77eb5df1a55e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0653b61b23eaa8308e30d42f5b273bffad3e4ce0c5a7704e571b77eb5df1a55e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0653b61b23eaa8308e30d42f5b273bffad3e4ce0c5a7704e571b77eb5df1a55e"
    sha256 cellar: :any_skip_relocation, sonoma:         "803df20ee5b6dc43d5623ed3985f6552143987252bedb7a2df08fb00e861944d"
    sha256 cellar: :any_skip_relocation, ventura:        "803df20ee5b6dc43d5623ed3985f6552143987252bedb7a2df08fb00e861944d"
    sha256 cellar: :any_skip_relocation, monterey:       "803df20ee5b6dc43d5623ed3985f6552143987252bedb7a2df08fb00e861944d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0653b61b23eaa8308e30d42f5b273bffad3e4ce0c5a7704e571b77eb5df1a55e"
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