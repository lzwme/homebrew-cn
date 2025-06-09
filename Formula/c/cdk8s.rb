class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.94.tgz"
  sha256 "3c99b13f33af5398ed2e2a7f2894031d4fa0e952f26afd4f58bdaabecffe246a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9688282f14631ecc0d393c6c056e220c73b1843463cb296e2e498b868da8d3e6"
    sha256 cellar: :any_skip_relocation, ventura:       "9688282f14631ecc0d393c6c056e220c73b1843463cb296e2e498b868da8d3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
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