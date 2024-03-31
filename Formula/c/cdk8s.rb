require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.89.tgz"
  sha256 "72db53b9f382b3e08dbe934956ab54beba853f7a0302cb88845d7cc2093a8590"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72ef8046c429a3418be5bef2318b1cc41a35a1ade812bb358c765b9e0a4d8213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72ef8046c429a3418be5bef2318b1cc41a35a1ade812bb358c765b9e0a4d8213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ef8046c429a3418be5bef2318b1cc41a35a1ade812bb358c765b9e0a4d8213"
    sha256 cellar: :any_skip_relocation, sonoma:         "68af835d80f95c3c9daed1728090f3f4164db0e7a1578cda4d90a9c54244b7fd"
    sha256 cellar: :any_skip_relocation, ventura:        "68af835d80f95c3c9daed1728090f3f4164db0e7a1578cda4d90a9c54244b7fd"
    sha256 cellar: :any_skip_relocation, monterey:       "68af835d80f95c3c9daed1728090f3f4164db0e7a1578cda4d90a9c54244b7fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ef8046c429a3418be5bef2318b1cc41a35a1ade812bb358c765b9e0a4d8213"
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