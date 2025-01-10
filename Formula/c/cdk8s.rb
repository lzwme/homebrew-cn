class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.295.tgz"
  sha256 "d2855f449416c3b04ea7f10de0a104098f96f9386128faf59eea2321cb9081ea"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f3cd3ead2dfd7bcb7953027e7a9a3f8556b6ff0c5362b326bba5155aea9ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2f3cd3ead2dfd7bcb7953027e7a9a3f8556b6ff0c5362b326bba5155aea9ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2f3cd3ead2dfd7bcb7953027e7a9a3f8556b6ff0c5362b326bba5155aea9ae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3d2e24afca82f8e52e2b844675297da2ef7926de8c14a1a38b1017d22bd115"
    sha256 cellar: :any_skip_relocation, ventura:       "cf3d2e24afca82f8e52e2b844675297da2ef7926de8c14a1a38b1017d22bd115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f3cd3ead2dfd7bcb7953027e7a9a3f8556b6ff0c5362b326bba5155aea9ae9"
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