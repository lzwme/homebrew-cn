class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.197.tgz"
  sha256 "750ce8c0e61cdb26b959ed9be502520f93bdc3577ee7f91d8aa564dfb063ad08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbd4ae6c87e8d869a4ef8cc50ceedaa1bc74295f34e198dca764d6ac0c05b54a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbd4ae6c87e8d869a4ef8cc50ceedaa1bc74295f34e198dca764d6ac0c05b54a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd4ae6c87e8d869a4ef8cc50ceedaa1bc74295f34e198dca764d6ac0c05b54a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f00917083f8c93d93b8ad3122bf74076670c27e8bc9a6e497fbc6eb4c47a42f8"
    sha256 cellar: :any_skip_relocation, ventura:        "f00917083f8c93d93b8ad3122bf74076670c27e8bc9a6e497fbc6eb4c47a42f8"
    sha256 cellar: :any_skip_relocation, monterey:       "f00917083f8c93d93b8ad3122bf74076670c27e8bc9a6e497fbc6eb4c47a42f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd4ae6c87e8d869a4ef8cc50ceedaa1bc74295f34e198dca764d6ac0c05b54a"
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