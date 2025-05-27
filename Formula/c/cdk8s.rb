class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.81.tgz"
  sha256 "ecbaec9268bf63cf15e08b4d7fb78d66ade18f688b359f1ba0c19e1847b9d122"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "942c586d21fc5f7664af2fb4ea90d087c3875ff90e12d4a1dfb38cb62f3ac8fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "942c586d21fc5f7664af2fb4ea90d087c3875ff90e12d4a1dfb38cb62f3ac8fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "942c586d21fc5f7664af2fb4ea90d087c3875ff90e12d4a1dfb38cb62f3ac8fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1331e2ec778640caca9701a1406e5ce690464d6f42f6bc58e10d73f3bc24a09c"
    sha256 cellar: :any_skip_relocation, ventura:       "1331e2ec778640caca9701a1406e5ce690464d6f42f6bc58e10d73f3bc24a09c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "942c586d21fc5f7664af2fb4ea90d087c3875ff90e12d4a1dfb38cb62f3ac8fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942c586d21fc5f7664af2fb4ea90d087c3875ff90e12d4a1dfb38cb62f3ac8fa"
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