class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.284.tgz"
  sha256 "1a492cb3dae107dae62fa27d1d8aa54c1e35061e68da0510f8ebf851635f557c"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92f7a1dfcc8e5f9b38f1586f001d1e27532ccb039c6304de49304f825ddf8f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b92f7a1dfcc8e5f9b38f1586f001d1e27532ccb039c6304de49304f825ddf8f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b92f7a1dfcc8e5f9b38f1586f001d1e27532ccb039c6304de49304f825ddf8f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "88716ff64be45b39066338a11fdb0a316a189ae15618352e63841f229bd02858"
    sha256 cellar: :any_skip_relocation, ventura:       "88716ff64be45b39066338a11fdb0a316a189ae15618352e63841f229bd02858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92f7a1dfcc8e5f9b38f1586f001d1e27532ccb039c6304de49304f825ddf8f8"
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