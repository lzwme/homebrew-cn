class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.330.tgz"
  sha256 "c8aa8e1675f95103e2532427190e8441bd1e70ee62fab9091e9cf9b2c1902462"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0073d1699ef7e6e538c6df9b0794bb8cc2e4b203d79c7baf9ad4a86e0fd2776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0073d1699ef7e6e538c6df9b0794bb8cc2e4b203d79c7baf9ad4a86e0fd2776"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0073d1699ef7e6e538c6df9b0794bb8cc2e4b203d79c7baf9ad4a86e0fd2776"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aceea29337c6ce510ad75b42cfdd5edef3966e9c222c90e420c0e5dbde49536"
    sha256 cellar: :any_skip_relocation, ventura:       "8aceea29337c6ce510ad75b42cfdd5edef3966e9c222c90e420c0e5dbde49536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0073d1699ef7e6e538c6df9b0794bb8cc2e4b203d79c7baf9ad4a86e0fd2776"
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