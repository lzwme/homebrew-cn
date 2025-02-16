class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.325.tgz"
  sha256 "b092eb286c77f6026ddbbd4bd59c643072bf24e8452838d95bedc059ca1efa8d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca43fabba3adfb4718f3c691e2b6a77342c4bb5c4b22bb1be7d64a970073bcd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca43fabba3adfb4718f3c691e2b6a77342c4bb5c4b22bb1be7d64a970073bcd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca43fabba3adfb4718f3c691e2b6a77342c4bb5c4b22bb1be7d64a970073bcd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "833631c3389e158428eb14b977a4b574f1bdc770b4d0557ecbe2692c6ea30808"
    sha256 cellar: :any_skip_relocation, ventura:       "833631c3389e158428eb14b977a4b574f1bdc770b4d0557ecbe2692c6ea30808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca43fabba3adfb4718f3c691e2b6a77342c4bb5c4b22bb1be7d64a970073bcd7"
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