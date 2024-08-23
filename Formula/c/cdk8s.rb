class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.196.tgz"
  sha256 "120f98bbc96230dd14f1719fbd1d56d664749d366e0692322e89c2a56209f4fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef11cb3834dad038e2cfd4816ae630bd5dc8d57436bca3b7927bf2a1e66abdcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef11cb3834dad038e2cfd4816ae630bd5dc8d57436bca3b7927bf2a1e66abdcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef11cb3834dad038e2cfd4816ae630bd5dc8d57436bca3b7927bf2a1e66abdcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "46afc713878ffec2533c7700029a65bdc70c999a72c2c08fc19ae7129706981c"
    sha256 cellar: :any_skip_relocation, ventura:        "46afc713878ffec2533c7700029a65bdc70c999a72c2c08fc19ae7129706981c"
    sha256 cellar: :any_skip_relocation, monterey:       "46afc713878ffec2533c7700029a65bdc70c999a72c2c08fc19ae7129706981c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef11cb3834dad038e2cfd4816ae630bd5dc8d57436bca3b7927bf2a1e66abdcb"
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