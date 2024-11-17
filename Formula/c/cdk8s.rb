class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.265.tgz"
  sha256 "0c0588f25f37e78a7c17494a0e277aa9f46ce85046cf59004428ab66ecdb3e77"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f31b056b38c4481822e6fb84e5a69a7c4b2276b2c507943dc88e956dd3eebc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f31b056b38c4481822e6fb84e5a69a7c4b2276b2c507943dc88e956dd3eebc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f31b056b38c4481822e6fb84e5a69a7c4b2276b2c507943dc88e956dd3eebc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d129b8fb8e9392c74608ae6303c013c63f0ed2e8a96c8a1111dd92cbc89ea210"
    sha256 cellar: :any_skip_relocation, ventura:       "d129b8fb8e9392c74608ae6303c013c63f0ed2e8a96c8a1111dd92cbc89ea210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f31b056b38c4481822e6fb84e5a69a7c4b2276b2c507943dc88e956dd3eebc6"
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