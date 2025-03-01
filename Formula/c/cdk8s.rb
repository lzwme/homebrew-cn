class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.3.tgz"
  sha256 "b23ba367a8eb871e0e5b2b08799146559ba6af994daaf0f6b70ed309e69fa49d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d62a2eae10d0fb70dd042de07f635fe919907d75804c71d71c0348b25d27cf55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d62a2eae10d0fb70dd042de07f635fe919907d75804c71d71c0348b25d27cf55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d62a2eae10d0fb70dd042de07f635fe919907d75804c71d71c0348b25d27cf55"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb07f9b2e5c74105c8dc08297f821229b7b35c71133c556116105456c4a25bd"
    sha256 cellar: :any_skip_relocation, ventura:       "4cb07f9b2e5c74105c8dc08297f821229b7b35c71133c556116105456c4a25bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d62a2eae10d0fb70dd042de07f635fe919907d75804c71d71c0348b25d27cf55"
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