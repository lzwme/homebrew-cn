class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.242.tgz"
  sha256 "3ba01780d9ccd68ddea62c56f62a65fc0ab5b7c765cae3a9c100730911683dbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6094db10c81c3398f11ba88e241c3dc1e209e05ab4634a08132b291ec2cb6e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6094db10c81c3398f11ba88e241c3dc1e209e05ab4634a08132b291ec2cb6e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6094db10c81c3398f11ba88e241c3dc1e209e05ab4634a08132b291ec2cb6e4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb90d75d2bd2eb52059c787e326789d47d8ed1ce5309cdd420e2c91f2f4289ef"
    sha256 cellar: :any_skip_relocation, ventura:       "eb90d75d2bd2eb52059c787e326789d47d8ed1ce5309cdd420e2c91f2f4289ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6094db10c81c3398f11ba88e241c3dc1e209e05ab4634a08132b291ec2cb6e4e"
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