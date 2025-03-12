class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.14.tgz"
  sha256 "38881b8c931b98849c8544ef85f36ec7169db4be167988a56573bf3b0a525d86"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dd00eaa7d6349332182f2d70289f43d4a6055d2c0b29706645c7e0bd8432cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dd00eaa7d6349332182f2d70289f43d4a6055d2c0b29706645c7e0bd8432cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dd00eaa7d6349332182f2d70289f43d4a6055d2c0b29706645c7e0bd8432cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "663273403b8933fe08477422994e39ee93ad5d66a57c5ebe8e485479bdcdfc5d"
    sha256 cellar: :any_skip_relocation, ventura:       "663273403b8933fe08477422994e39ee93ad5d66a57c5ebe8e485479bdcdfc5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd00eaa7d6349332182f2d70289f43d4a6055d2c0b29706645c7e0bd8432cef"
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