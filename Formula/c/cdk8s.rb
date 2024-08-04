class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.178.tgz"
  sha256 "028d5595afbe73d820febfd2264ca0f3bef1763e0118d5b89e49a25cf195ab4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f363d662f0fabd4917a75f48b4f981c859d8cc13d08341d79951c578bf4b880"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f363d662f0fabd4917a75f48b4f981c859d8cc13d08341d79951c578bf4b880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f363d662f0fabd4917a75f48b4f981c859d8cc13d08341d79951c578bf4b880"
    sha256 cellar: :any_skip_relocation, sonoma:         "53375cfc3de5f5e57c414aafebd6c3b3a494ef5707c6f488abd74a4be50c8043"
    sha256 cellar: :any_skip_relocation, ventura:        "53375cfc3de5f5e57c414aafebd6c3b3a494ef5707c6f488abd74a4be50c8043"
    sha256 cellar: :any_skip_relocation, monterey:       "53375cfc3de5f5e57c414aafebd6c3b3a494ef5707c6f488abd74a4be50c8043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f363d662f0fabd4917a75f48b4f981c859d8cc13d08341d79951c578bf4b880"
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