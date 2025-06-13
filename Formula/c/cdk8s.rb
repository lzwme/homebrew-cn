class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.98.tgz"
  sha256 "7d79fbd3710a39102b5fcf03e7879b26efa9ba10ffb594aa700ea12526182d57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78234c1485fca7dd81dd904fe05e069a48c2db53153f43daac3079bfd50f5fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78234c1485fca7dd81dd904fe05e069a48c2db53153f43daac3079bfd50f5fbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78234c1485fca7dd81dd904fe05e069a48c2db53153f43daac3079bfd50f5fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "136a09930954161b2c8c31e2056bc9e538160a88491879fbaccfd2713dcee308"
    sha256 cellar: :any_skip_relocation, ventura:       "136a09930954161b2c8c31e2056bc9e538160a88491879fbaccfd2713dcee308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78234c1485fca7dd81dd904fe05e069a48c2db53153f43daac3079bfd50f5fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78234c1485fca7dd81dd904fe05e069a48c2db53153f43daac3079bfd50f5fbf"
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