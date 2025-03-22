class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.24.tgz"
  sha256 "39ad4032fad4f4163d50c7a672756378f55a208d4a8c841f100a2737f82356e0"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8648c1eac31eba058b8ff6af2f0867aae32b723bc6bd4edd56d67e8d7665c1ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8648c1eac31eba058b8ff6af2f0867aae32b723bc6bd4edd56d67e8d7665c1ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8648c1eac31eba058b8ff6af2f0867aae32b723bc6bd4edd56d67e8d7665c1ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "933ace1ed26389e619bc9137165adfb33c8aef6a36a960365b01319851f75a75"
    sha256 cellar: :any_skip_relocation, ventura:       "933ace1ed26389e619bc9137165adfb33c8aef6a36a960365b01319851f75a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8648c1eac31eba058b8ff6af2f0867aae32b723bc6bd4edd56d67e8d7665c1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8648c1eac31eba058b8ff6af2f0867aae32b723bc6bd4edd56d67e8d7665c1ca"
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