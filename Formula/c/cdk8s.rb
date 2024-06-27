require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.156.tgz"
  sha256 "4e3fcb57c7f37c83cd031a00dc4a54ef755106e8cf3ce6623a47236c733e98e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0275521bdb86b4536daf684a900b6dff126082c935c1648bc954ef1cfa0043c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0275521bdb86b4536daf684a900b6dff126082c935c1648bc954ef1cfa0043c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0275521bdb86b4536daf684a900b6dff126082c935c1648bc954ef1cfa0043c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d83e7ecc61393b6a733a9687ec1d008173e08d174e18ff83d54838e44364676c"
    sha256 cellar: :any_skip_relocation, ventura:        "d83e7ecc61393b6a733a9687ec1d008173e08d174e18ff83d54838e44364676c"
    sha256 cellar: :any_skip_relocation, monterey:       "d83e7ecc61393b6a733a9687ec1d008173e08d174e18ff83d54838e44364676c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b72428e7bdd8d91012c77eedfb255bceede5519b9f144f5a7dc4eb2412af7c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end