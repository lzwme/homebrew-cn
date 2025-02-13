class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.322.tgz"
  sha256 "a589ccb9b339cca6b38abba0eb190dacb5fbb7f0778eacae0d2efb05b5d67c2a"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57cc766d71c160f461e849149dc266f04da4399058594c8bce3c09d6ba9d0841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57cc766d71c160f461e849149dc266f04da4399058594c8bce3c09d6ba9d0841"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57cc766d71c160f461e849149dc266f04da4399058594c8bce3c09d6ba9d0841"
    sha256 cellar: :any_skip_relocation, sonoma:        "6506a76e679dc32506ad4692f6c2783bb71910a8129426226f43bf278ef1cc01"
    sha256 cellar: :any_skip_relocation, ventura:       "6506a76e679dc32506ad4692f6c2783bb71910a8129426226f43bf278ef1cc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57cc766d71c160f461e849149dc266f04da4399058594c8bce3c09d6ba9d0841"
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