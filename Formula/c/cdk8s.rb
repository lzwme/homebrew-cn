class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.233.tgz"
  sha256 "da971e3504a91c613d12e46dbcc4a1bd60d41d18614e955cabe381bae27435e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b297f88a2ef2e5f83993fa2ba163dd48819898f204611629eedf389221c9b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5b297f88a2ef2e5f83993fa2ba163dd48819898f204611629eedf389221c9b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5b297f88a2ef2e5f83993fa2ba163dd48819898f204611629eedf389221c9b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ce69e459a0a646d8561cac151b3b1cfd4c71b4ae9e28d29184f033612970054"
    sha256 cellar: :any_skip_relocation, ventura:       "6ce69e459a0a646d8561cac151b3b1cfd4c71b4ae9e28d29184f033612970054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b297f88a2ef2e5f83993fa2ba163dd48819898f204611629eedf389221c9b5"
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