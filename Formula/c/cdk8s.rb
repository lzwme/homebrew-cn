class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.275.tgz"
  sha256 "7ac2901efa5f3ff3006f77279ffa602548bf31c7486ecfe8da9e8e3e3a9e249a"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c0e7e8bab6d9f5609bd06e2df49872d737517f47746b842982d60ec07c9a7e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c0e7e8bab6d9f5609bd06e2df49872d737517f47746b842982d60ec07c9a7e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c0e7e8bab6d9f5609bd06e2df49872d737517f47746b842982d60ec07c9a7e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf6a695caf782546f37fce5e67392c4147bdf46203711c1a7da33d7640afd41"
    sha256 cellar: :any_skip_relocation, ventura:       "0bf6a695caf782546f37fce5e67392c4147bdf46203711c1a7da33d7640afd41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0e7e8bab6d9f5609bd06e2df49872d737517f47746b842982d60ec07c9a7e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end