class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.48.tgz"
  sha256 "fea554a9d7d4eb72947e431031114931ccf11dd174559f5bc1d16c8745d39180"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36de3134a4f0a1851fc79e5940c1d96f603f550eae7cfa47b2411def8cd763b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36de3134a4f0a1851fc79e5940c1d96f603f550eae7cfa47b2411def8cd763b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36de3134a4f0a1851fc79e5940c1d96f603f550eae7cfa47b2411def8cd763b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa65ea97a1fea2ac3010bd8082746d4f47af326c8d24166f260a4ad83e65ba7f"
    sha256 cellar: :any_skip_relocation, ventura:       "aa65ea97a1fea2ac3010bd8082746d4f47af326c8d24166f260a4ad83e65ba7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36de3134a4f0a1851fc79e5940c1d96f603f550eae7cfa47b2411def8cd763b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36de3134a4f0a1851fc79e5940c1d96f603f550eae7cfa47b2411def8cd763b0"
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