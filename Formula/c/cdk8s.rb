class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.13.tgz"
  sha256 "02e454d3c030d4443ae29f0479aa51609ae84e620f147cf2642701dcd416527b"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42a9b4eaa1bc115e2ba517df56ab74ae96e343e46b259b9ec8a9e06414c7bd07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a9b4eaa1bc115e2ba517df56ab74ae96e343e46b259b9ec8a9e06414c7bd07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42a9b4eaa1bc115e2ba517df56ab74ae96e343e46b259b9ec8a9e06414c7bd07"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a667379ec4d2b8588f472e5acfaecbc350935eb8f5c5c8bdbe4947e97995a6e"
    sha256 cellar: :any_skip_relocation, ventura:       "9a667379ec4d2b8588f472e5acfaecbc350935eb8f5c5c8bdbe4947e97995a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a9b4eaa1bc115e2ba517df56ab74ae96e343e46b259b9ec8a9e06414c7bd07"
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