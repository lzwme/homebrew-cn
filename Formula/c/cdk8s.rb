class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.26.tgz"
  sha256 "4a7a17b69778fceacc6342d12f319aeb40957172385c2082e30f5cc2c4637070"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e585ad767886b982dcc10b2d0a0b0be59748cce84a29c551f5dfc0c531174dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e585ad767886b982dcc10b2d0a0b0be59748cce84a29c551f5dfc0c531174dd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e585ad767886b982dcc10b2d0a0b0be59748cce84a29c551f5dfc0c531174dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb8a43dca4f871228a90c137ba824bf90117daccf30004337f7dff975e4b549"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb8a43dca4f871228a90c137ba824bf90117daccf30004337f7dff975e4b549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e585ad767886b982dcc10b2d0a0b0be59748cce84a29c551f5dfc0c531174dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e585ad767886b982dcc10b2d0a0b0be59748cce84a29c551f5dfc0c531174dd2"
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