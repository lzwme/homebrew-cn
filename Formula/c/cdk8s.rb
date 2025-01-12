class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.297.tgz"
  sha256 "57a9277e8b77629642b4ed917b860ffd488f8adb0f656fca02593c9a93d524a0"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06072f43420ddb454d4a38e107390f26157f500897567707d6226718073b84c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06072f43420ddb454d4a38e107390f26157f500897567707d6226718073b84c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06072f43420ddb454d4a38e107390f26157f500897567707d6226718073b84c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd0cd8bf0aecc5d90c50d26e3babd740d501819dd02da6bea46c0c01d56d2f4"
    sha256 cellar: :any_skip_relocation, ventura:       "0fd0cd8bf0aecc5d90c50d26e3babd740d501819dd02da6bea46c0c01d56d2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06072f43420ddb454d4a38e107390f26157f500897567707d6226718073b84c2"
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