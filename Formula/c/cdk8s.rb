class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.201.tgz"
  sha256 "72de45bf5437f855f5a25ed1df0ad60cc5408b8d3f9ae0df57e80022fd4d1c8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73258aab7d3baf0819d0d0c1a0a23aa385957352e882efe8a0cbfd6b4353e67e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73258aab7d3baf0819d0d0c1a0a23aa385957352e882efe8a0cbfd6b4353e67e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73258aab7d3baf0819d0d0c1a0a23aa385957352e882efe8a0cbfd6b4353e67e"
    sha256 cellar: :any_skip_relocation, sonoma:         "485385dbebe2fd30c6deef907737c3069c5cb251d345aaaf5e42ea8f13a6d9da"
    sha256 cellar: :any_skip_relocation, ventura:        "485385dbebe2fd30c6deef907737c3069c5cb251d345aaaf5e42ea8f13a6d9da"
    sha256 cellar: :any_skip_relocation, monterey:       "485385dbebe2fd30c6deef907737c3069c5cb251d345aaaf5e42ea8f13a6d9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73258aab7d3baf0819d0d0c1a0a23aa385957352e882efe8a0cbfd6b4353e67e"
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