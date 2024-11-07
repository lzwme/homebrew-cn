class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.255.tgz"
  sha256 "1f89d6b7e36c78e22504296f6abbc38f48650743834f8103133e23f612937fd5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ce46aa94a2ccdc2b8926ee39743f57e364943ebc0006333fde9e4fd4586bd45"
    sha256 cellar: :any_skip_relocation, ventura:       "7ce46aa94a2ccdc2b8926ee39743f57e364943ebc0006333fde9e4fd4586bd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end