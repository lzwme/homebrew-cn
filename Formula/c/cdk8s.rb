class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.204.tgz"
  sha256 "bbe30bb705f2eac7244203674c037dba22c429931b978b3c095a516867bba19f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "132ca4786da64ce215eb0879215d8976b3e0073aa58cc39143bd3e8d1b0c55ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132ca4786da64ce215eb0879215d8976b3e0073aa58cc39143bd3e8d1b0c55ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "132ca4786da64ce215eb0879215d8976b3e0073aa58cc39143bd3e8d1b0c55ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "5839091d3fdea51193b4be7978c5a6a9fbb9008b8576bbf868de9c4f088be5d2"
    sha256 cellar: :any_skip_relocation, ventura:        "5839091d3fdea51193b4be7978c5a6a9fbb9008b8576bbf868de9c4f088be5d2"
    sha256 cellar: :any_skip_relocation, monterey:       "5839091d3fdea51193b4be7978c5a6a9fbb9008b8576bbf868de9c4f088be5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132ca4786da64ce215eb0879215d8976b3e0073aa58cc39143bd3e8d1b0c55ac"
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