class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.91.tgz"
  sha256 "6b82784e48d50ac197383f043dafd6fb01f9e1e6e184e22afd16c4433a65e092"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32bd9adff950f0b99b430587fd48532226a9a090a79e797353acb6736bbbcbac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32bd9adff950f0b99b430587fd48532226a9a090a79e797353acb6736bbbcbac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32bd9adff950f0b99b430587fd48532226a9a090a79e797353acb6736bbbcbac"
    sha256 cellar: :any_skip_relocation, sonoma:        "43349a0f0e6d6dcb20a9d2c8938afaba8a60d81801e66f8c4a02feaf90fdb40e"
    sha256 cellar: :any_skip_relocation, ventura:       "43349a0f0e6d6dcb20a9d2c8938afaba8a60d81801e66f8c4a02feaf90fdb40e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32bd9adff950f0b99b430587fd48532226a9a090a79e797353acb6736bbbcbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32bd9adff950f0b99b430587fd48532226a9a090a79e797353acb6736bbbcbac"
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