class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.236.tgz"
  sha256 "34f3052721d61b35f1bd7ab4585fa8c55bdbe30c7ad4de65eac1b17fea3ab31f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8e66c72dc40f36924b72a26e287464ba049d7f272902dcb78a203b49268a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8e66c72dc40f36924b72a26e287464ba049d7f272902dcb78a203b49268a8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed8e66c72dc40f36924b72a26e287464ba049d7f272902dcb78a203b49268a8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e7bc8a68d04bcf11ac1e0de2fe26b6d2db171f79ac74930cbb639004759ec2"
    sha256 cellar: :any_skip_relocation, ventura:       "30e7bc8a68d04bcf11ac1e0de2fe26b6d2db171f79ac74930cbb639004759ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8e66c72dc40f36924b72a26e287464ba049d7f272902dcb78a203b49268a8a"
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