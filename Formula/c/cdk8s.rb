class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.332.tgz"
  sha256 "b5541c587a6f3454c9be6c50e6a0796931e2cfdbe7126d0121f08337a0708531"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
    sha256 cellar: :any_skip_relocation, sonoma:        "6941608c7e577c3b4c4902220ba30527299924997d0c3e0648514ad6e1ee8d74"
    sha256 cellar: :any_skip_relocation, ventura:       "6941608c7e577c3b4c4902220ba30527299924997d0c3e0648514ad6e1ee8d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
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