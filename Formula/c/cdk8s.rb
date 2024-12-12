class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.280.tgz"
  sha256 "b54de14ef007df6eaa62a2118515de5ebe8187a940586248788f07b9c55bb459"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df8e20eaebf1d7d1ac9b34b40caf39ba19d435719811411672104861eaca3460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8e20eaebf1d7d1ac9b34b40caf39ba19d435719811411672104861eaca3460"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df8e20eaebf1d7d1ac9b34b40caf39ba19d435719811411672104861eaca3460"
    sha256 cellar: :any_skip_relocation, sonoma:        "f152102bf2e2588b06dc011e7ce92e940e70181652663b27a7c1133c79418d67"
    sha256 cellar: :any_skip_relocation, ventura:       "f152102bf2e2588b06dc011e7ce92e940e70181652663b27a7c1133c79418d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8e20eaebf1d7d1ac9b34b40caf39ba19d435719811411672104861eaca3460"
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