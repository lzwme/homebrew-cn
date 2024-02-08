require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.42.tgz"
  sha256 "4eb266c21ab39032a15050cf440c55be437ef00e40ba1939c96b333238d25e67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e880554e5a2c3d55eb414e00f538f10b566d94ab61621df31ea791253574738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e880554e5a2c3d55eb414e00f538f10b566d94ab61621df31ea791253574738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e880554e5a2c3d55eb414e00f538f10b566d94ab61621df31ea791253574738"
    sha256 cellar: :any_skip_relocation, sonoma:         "60554086c3b52027ae87dee0f317e257f280a35bcc183d6b6097557f0216cb13"
    sha256 cellar: :any_skip_relocation, ventura:        "60554086c3b52027ae87dee0f317e257f280a35bcc183d6b6097557f0216cb13"
    sha256 cellar: :any_skip_relocation, monterey:       "60554086c3b52027ae87dee0f317e257f280a35bcc183d6b6097557f0216cb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e880554e5a2c3d55eb414e00f538f10b566d94ab61621df31ea791253574738"
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