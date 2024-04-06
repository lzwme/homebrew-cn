require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.92.tgz"
  sha256 "36b99f7b403e86d6fa43ef57e7272b369bd354ed01d113d7c716fee78d512656"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6139af22f7f71f6aa06f26cdcef6e25873f57756746f0a2e267c09ec133a1950"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6139af22f7f71f6aa06f26cdcef6e25873f57756746f0a2e267c09ec133a1950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6139af22f7f71f6aa06f26cdcef6e25873f57756746f0a2e267c09ec133a1950"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed74904eaa29ae800a29862a911b65df998e02cb805196e40472d844b64f3c39"
    sha256 cellar: :any_skip_relocation, ventura:        "ed74904eaa29ae800a29862a911b65df998e02cb805196e40472d844b64f3c39"
    sha256 cellar: :any_skip_relocation, monterey:       "ed74904eaa29ae800a29862a911b65df998e02cb805196e40472d844b64f3c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6139af22f7f71f6aa06f26cdcef6e25873f57756746f0a2e267c09ec133a1950"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end