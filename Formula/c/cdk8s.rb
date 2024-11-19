class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.267.tgz"
  sha256 "6d3c48cb8009aea8655a151f32f72a299d6e8c7a7a85d233b691d1ed697da041"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03a8583ba48a204826987f9b2e698ce1058ecb12ddb26f79b923e0f0d9143d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03a8583ba48a204826987f9b2e698ce1058ecb12ddb26f79b923e0f0d9143d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03a8583ba48a204826987f9b2e698ce1058ecb12ddb26f79b923e0f0d9143d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "32094b1420173d679e1f1d153f16d2959cbb314967409e4709e9ab6767d96407"
    sha256 cellar: :any_skip_relocation, ventura:       "32094b1420173d679e1f1d153f16d2959cbb314967409e4709e9ab6767d96407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a8583ba48a204826987f9b2e698ce1058ecb12ddb26f79b923e0f0d9143d37"
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