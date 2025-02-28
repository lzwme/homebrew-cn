class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.2.tgz"
  sha256 "8fdf6be23350116f5b921539d5e96d521768abf8ac198d9a746a8e145a445ac5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd06f5fe3c18fe82e6d4064fd8f6570de933120c6f3014be13063b199e9037b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd06f5fe3c18fe82e6d4064fd8f6570de933120c6f3014be13063b199e9037b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd06f5fe3c18fe82e6d4064fd8f6570de933120c6f3014be13063b199e9037b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a68218c2c4e2af705389aa982bb2f3d88a9a40a0e2b2336c99f645be488f325"
    sha256 cellar: :any_skip_relocation, ventura:       "3a68218c2c4e2af705389aa982bb2f3d88a9a40a0e2b2336c99f645be488f325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd06f5fe3c18fe82e6d4064fd8f6570de933120c6f3014be13063b199e9037b7"
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