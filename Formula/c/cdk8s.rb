class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.260.tgz"
  sha256 "9635a3fe1eeed419a3c52f4c19690aae10a2c461e130e4c55faa8669b0c28c43"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3adbd99d8ac5f88525b9d22adf591cc1ab4e2046303058d223aeed783f2b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3adbd99d8ac5f88525b9d22adf591cc1ab4e2046303058d223aeed783f2b5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af3adbd99d8ac5f88525b9d22adf591cc1ab4e2046303058d223aeed783f2b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "580a12d4c3e1d5003eb2cf451937ec7d8f624132425dbc76a772c824dacb730f"
    sha256 cellar: :any_skip_relocation, ventura:       "580a12d4c3e1d5003eb2cf451937ec7d8f624132425dbc76a772c824dacb730f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3adbd99d8ac5f88525b9d22adf591cc1ab4e2046303058d223aeed783f2b5d"
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