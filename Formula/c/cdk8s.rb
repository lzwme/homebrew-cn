class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.287.tgz"
  sha256 "b288cbed291fcf82515cb07c4dfb37455bbc33b019914c06805f2d96566999fc"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e2f7f5552b3548c0823dee3f6f508cec170f3b1d387f230425a53c0ed08436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e2f7f5552b3548c0823dee3f6f508cec170f3b1d387f230425a53c0ed08436"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3e2f7f5552b3548c0823dee3f6f508cec170f3b1d387f230425a53c0ed08436"
    sha256 cellar: :any_skip_relocation, sonoma:        "69c57a807bcc92fd70b579f1257e0a59edeaa815379a34e11aa862fa6b25dbbf"
    sha256 cellar: :any_skip_relocation, ventura:       "69c57a807bcc92fd70b579f1257e0a59edeaa815379a34e11aa862fa6b25dbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e2f7f5552b3548c0823dee3f6f508cec170f3b1d387f230425a53c0ed08436"
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