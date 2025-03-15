class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.17.tgz"
  sha256 "056a366f31dfe56dd597c0223cb4c9265cd4059a8e7a70b8dad571965aa4355d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
    sha256 cellar: :any_skip_relocation, sonoma:        "2963ba9e132c5962cebe9dc47bdfff44c524f1ef70b10663c4780748a01271f0"
    sha256 cellar: :any_skip_relocation, ventura:       "2963ba9e132c5962cebe9dc47bdfff44c524f1ef70b10663c4780748a01271f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
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