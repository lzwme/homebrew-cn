class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.59.tgz"
  sha256 "cb750447058508d0109cacb3781eea3425adac410d5a146936235c0c498f64d0"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51efa4e074c48e0cba5ba047fd1a5a807d4bdec894ab19e288f4b79e55c664c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51efa4e074c48e0cba5ba047fd1a5a807d4bdec894ab19e288f4b79e55c664c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51efa4e074c48e0cba5ba047fd1a5a807d4bdec894ab19e288f4b79e55c664c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd4501342cce893905ef67af866cad5fceb060201c2f2054e5fa153024af716"
    sha256 cellar: :any_skip_relocation, ventura:       "5cd4501342cce893905ef67af866cad5fceb060201c2f2054e5fa153024af716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51efa4e074c48e0cba5ba047fd1a5a807d4bdec894ab19e288f4b79e55c664c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51efa4e074c48e0cba5ba047fd1a5a807d4bdec894ab19e288f4b79e55c664c8"
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