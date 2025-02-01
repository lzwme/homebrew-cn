class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.310.tgz"
  sha256 "3250d5fc5fe6dd804cf8259e79f05334836f1f527ad6577e202c115ff328bd84"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def1a646b208f19c63efebe1051573eceb0d5c5c6304a49976bc288d9b45d835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "def1a646b208f19c63efebe1051573eceb0d5c5c6304a49976bc288d9b45d835"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "def1a646b208f19c63efebe1051573eceb0d5c5c6304a49976bc288d9b45d835"
    sha256 cellar: :any_skip_relocation, sonoma:        "7965467e911932be8ebada62c4cdc8e66a2624348ca089c8ddbe6a1b4fcf88a8"
    sha256 cellar: :any_skip_relocation, ventura:       "7965467e911932be8ebada62c4cdc8e66a2624348ca089c8ddbe6a1b4fcf88a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def1a646b208f19c63efebe1051573eceb0d5c5c6304a49976bc288d9b45d835"
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