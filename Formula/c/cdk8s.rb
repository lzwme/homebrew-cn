class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.317.tgz"
  sha256 "f442d39176aea2fd582d03494b6aed1f8685a7644fa9bbe6dc0fa6ff180ef23e"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92894410bbb5f5b3dec4facac4d4cd9d773958698cfe9091755530a5b5c8f5f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92894410bbb5f5b3dec4facac4d4cd9d773958698cfe9091755530a5b5c8f5f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92894410bbb5f5b3dec4facac4d4cd9d773958698cfe9091755530a5b5c8f5f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e8a105c73b26e22a36cdeebe260fba7087cc57c9320c6c8787700db040a3856"
    sha256 cellar: :any_skip_relocation, ventura:       "5e8a105c73b26e22a36cdeebe260fba7087cc57c9320c6c8787700db040a3856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92894410bbb5f5b3dec4facac4d4cd9d773958698cfe9091755530a5b5c8f5f8"
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