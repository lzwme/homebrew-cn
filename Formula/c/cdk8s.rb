class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.64.tgz"
  sha256 "9ca3fc24103218fc6d2bf0e2e698a65db6ae9813659948bf8c24272965649508"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7674735ad35dca33f679601370c04bcf1334563ddf9514b78faf5c917514d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7674735ad35dca33f679601370c04bcf1334563ddf9514b78faf5c917514d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7674735ad35dca33f679601370c04bcf1334563ddf9514b78faf5c917514d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "532eff7ec55d9977f5352a241739fb2878fd98c45c1357de1a41e49b60e0ddbc"
    sha256 cellar: :any_skip_relocation, ventura:       "532eff7ec55d9977f5352a241739fb2878fd98c45c1357de1a41e49b60e0ddbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7674735ad35dca33f679601370c04bcf1334563ddf9514b78faf5c917514d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7674735ad35dca33f679601370c04bcf1334563ddf9514b78faf5c917514d90"
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