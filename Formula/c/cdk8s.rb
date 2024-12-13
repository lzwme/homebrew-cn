class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.281.tgz"
  sha256 "f76acf6d6dbad499dd54247ac964892821fc0c77cefdb4f10710c6bda7aba298"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75aed99b099110c8ca4c75fb4b732714e1152763b2e863209dfd83aebaf8826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75aed99b099110c8ca4c75fb4b732714e1152763b2e863209dfd83aebaf8826"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b75aed99b099110c8ca4c75fb4b732714e1152763b2e863209dfd83aebaf8826"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9fbd3ac6c82d6e0747b70542e1587a278e310a6cff127f934b148dc92e1fc2c"
    sha256 cellar: :any_skip_relocation, ventura:       "a9fbd3ac6c82d6e0747b70542e1587a278e310a6cff127f934b148dc92e1fc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75aed99b099110c8ca4c75fb4b732714e1152763b2e863209dfd83aebaf8826"
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