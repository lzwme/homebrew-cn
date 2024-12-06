class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.274.tgz"
  sha256 "82489c09fd58e01d3caac3415cfec0f53608235e9cbc7090f439a847b466eec1"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9dd84ac7af5e99c9fac2de27222c4ea9a3f94d88f7c3a62bbecb7eb2388311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9dd84ac7af5e99c9fac2de27222c4ea9a3f94d88f7c3a62bbecb7eb2388311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e9dd84ac7af5e99c9fac2de27222c4ea9a3f94d88f7c3a62bbecb7eb2388311"
    sha256 cellar: :any_skip_relocation, sonoma:        "202b70372eff09f655793c0d9eed610792324a158c996b9f211ab4508ae960e9"
    sha256 cellar: :any_skip_relocation, ventura:       "202b70372eff09f655793c0d9eed610792324a158c996b9f211ab4508ae960e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9dd84ac7af5e99c9fac2de27222c4ea9a3f94d88f7c3a62bbecb7eb2388311"
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