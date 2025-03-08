class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.10.tgz"
  sha256 "e20f953cbcbd20740655c68e26e7c9867f540522d088b064196fc16a4f07de74"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e0abfaa7fcec320c90cc682eaf00d64a6effebb0375c4d4856b12ea584d25d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36e0abfaa7fcec320c90cc682eaf00d64a6effebb0375c4d4856b12ea584d25d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36e0abfaa7fcec320c90cc682eaf00d64a6effebb0375c4d4856b12ea584d25d"
    sha256 cellar: :any_skip_relocation, sonoma:        "99dfbbdcccda4fb1d5363c39fc77fd0aba1a8e99b8576a43ed4b2f7e245a4c9d"
    sha256 cellar: :any_skip_relocation, ventura:       "99dfbbdcccda4fb1d5363c39fc77fd0aba1a8e99b8576a43ed4b2f7e245a4c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36e0abfaa7fcec320c90cc682eaf00d64a6effebb0375c4d4856b12ea584d25d"
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