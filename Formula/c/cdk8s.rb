class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.37.tgz"
  sha256 "586bf716df5789394d043b98e77367da982a9e135d3a5bf76b5acf7436562369"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b150780ea2b039696287b6d1f83342524aac5a06dc202261f1f3cd67b4c07b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b150780ea2b039696287b6d1f83342524aac5a06dc202261f1f3cd67b4c07b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b150780ea2b039696287b6d1f83342524aac5a06dc202261f1f3cd67b4c07b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "06804e8363fa53d763692f4a0437310af5592e92b26bcd34b28aac2c0e55eb7f"
    sha256 cellar: :any_skip_relocation, ventura:       "06804e8363fa53d763692f4a0437310af5592e92b26bcd34b28aac2c0e55eb7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b150780ea2b039696287b6d1f83342524aac5a06dc202261f1f3cd67b4c07b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b150780ea2b039696287b6d1f83342524aac5a06dc202261f1f3cd67b4c07b4"
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