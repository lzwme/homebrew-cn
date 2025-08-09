class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.149.tgz"
  sha256 "91531601d2c3c03090c2b23292eed6af5556f2a31a51bab48693d83b835c6c2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af70f1f8ec7365d54e54f8b53f6dfcda85d799bee54ff79b2586572ff0388168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af70f1f8ec7365d54e54f8b53f6dfcda85d799bee54ff79b2586572ff0388168"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af70f1f8ec7365d54e54f8b53f6dfcda85d799bee54ff79b2586572ff0388168"
    sha256 cellar: :any_skip_relocation, sonoma:        "7305980329f39feb66141df5d38666d6508e0e2ca373acd03e3f3e03745173f8"
    sha256 cellar: :any_skip_relocation, ventura:       "7305980329f39feb66141df5d38666d6508e0e2ca373acd03e3f3e03745173f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af70f1f8ec7365d54e54f8b53f6dfcda85d799bee54ff79b2586572ff0388168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af70f1f8ec7365d54e54f8b53f6dfcda85d799bee54ff79b2586572ff0388168"
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