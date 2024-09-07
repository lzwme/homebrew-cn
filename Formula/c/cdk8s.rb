class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.209.tgz"
  sha256 "339fcbc736b137613964da5dd5431c1639046e61bfaf8160be0772d3c6920720"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "536cdff31712ceba4d28e26c2158c15bc181f99cc1b5d88b6ac3b5c2c0bb1e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "536cdff31712ceba4d28e26c2158c15bc181f99cc1b5d88b6ac3b5c2c0bb1e9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536cdff31712ceba4d28e26c2158c15bc181f99cc1b5d88b6ac3b5c2c0bb1e9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "51654c3d22273fb74ee8de024ccbcb931459951e72f4b91831e77a3df064eaf5"
    sha256 cellar: :any_skip_relocation, ventura:        "51654c3d22273fb74ee8de024ccbcb931459951e72f4b91831e77a3df064eaf5"
    sha256 cellar: :any_skip_relocation, monterey:       "51654c3d22273fb74ee8de024ccbcb931459951e72f4b91831e77a3df064eaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536cdff31712ceba4d28e26c2158c15bc181f99cc1b5d88b6ac3b5c2c0bb1e9d"
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