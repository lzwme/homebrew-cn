class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.324.tgz"
  sha256 "be08bfd90e81b63b0636a686c226ef205ce5873eae52ba5e891aced8f1a2ded0"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9673cd2de622e73ca8a1a9cb2db3c658eeac0d429d19906a2104f257f9fcb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd9673cd2de622e73ca8a1a9cb2db3c658eeac0d429d19906a2104f257f9fcb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd9673cd2de622e73ca8a1a9cb2db3c658eeac0d429d19906a2104f257f9fcb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a08ca28022a64c8b6a876ec0f928675aa256a2fa7ffc787ec79c22f6ec9f9e6e"
    sha256 cellar: :any_skip_relocation, ventura:       "a08ca28022a64c8b6a876ec0f928675aa256a2fa7ffc787ec79c22f6ec9f9e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9673cd2de622e73ca8a1a9cb2db3c658eeac0d429d19906a2104f257f9fcb0"
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