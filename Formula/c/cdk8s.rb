class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.307.tgz"
  sha256 "eaacfe77f929723451a37220a2cb882d2a732a217f86e1d9a1471ff8b1acafe9"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c34b856be4165067d04899d8f924a7d831d3bd5ab7acd62c6c94e5a78db0601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c34b856be4165067d04899d8f924a7d831d3bd5ab7acd62c6c94e5a78db0601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c34b856be4165067d04899d8f924a7d831d3bd5ab7acd62c6c94e5a78db0601"
    sha256 cellar: :any_skip_relocation, sonoma:        "db46ce0eb04ad0657b3e5d0300ecc8e4e47b6ad7fa2e207445a2454ddae958f5"
    sha256 cellar: :any_skip_relocation, ventura:       "db46ce0eb04ad0657b3e5d0300ecc8e4e47b6ad7fa2e207445a2454ddae958f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c34b856be4165067d04899d8f924a7d831d3bd5ab7acd62c6c94e5a78db0601"
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