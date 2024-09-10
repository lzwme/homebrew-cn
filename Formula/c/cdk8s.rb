class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.212.tgz"
  sha256 "5621fd9fbd8147980617c7635e59acf1a35f95bd287065b2161426dc281bb652"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "452a4af5614b7a807be5ba709c76cc6362594dc6dd1ba832bbd7e62ee420756f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "452a4af5614b7a807be5ba709c76cc6362594dc6dd1ba832bbd7e62ee420756f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "452a4af5614b7a807be5ba709c76cc6362594dc6dd1ba832bbd7e62ee420756f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5022497a9fb988be8eb5a625cfabef7d0ce919a6078e32a275e0c530ef735d4"
    sha256 cellar: :any_skip_relocation, ventura:        "d5022497a9fb988be8eb5a625cfabef7d0ce919a6078e32a275e0c530ef735d4"
    sha256 cellar: :any_skip_relocation, monterey:       "d5022497a9fb988be8eb5a625cfabef7d0ce919a6078e32a275e0c530ef735d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "452a4af5614b7a807be5ba709c76cc6362594dc6dd1ba832bbd7e62ee420756f"
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