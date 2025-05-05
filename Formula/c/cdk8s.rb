class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.60.tgz"
  sha256 "2a37a86129fcc9e075489b0dd6081fde446ef006edfa910c8b14007d8d77aa89"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e664816f23ae84b89508d5b537c3edab7a67f68c127f27e3b9e2c86631d9525f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e664816f23ae84b89508d5b537c3edab7a67f68c127f27e3b9e2c86631d9525f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e664816f23ae84b89508d5b537c3edab7a67f68c127f27e3b9e2c86631d9525f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a23663eebabf07b11a690d4b7f483c85cbbdd8f0fe07156620a629d8824c5a"
    sha256 cellar: :any_skip_relocation, ventura:       "e4a23663eebabf07b11a690d4b7f483c85cbbdd8f0fe07156620a629d8824c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e664816f23ae84b89508d5b537c3edab7a67f68c127f27e3b9e2c86631d9525f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e664816f23ae84b89508d5b537c3edab7a67f68c127f27e3b9e2c86631d9525f"
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