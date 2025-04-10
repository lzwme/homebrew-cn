class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.38.tgz"
  sha256 "45a27f1f2ee03a858ff87b724bcb305662ec04b7cc63d27f004be27658ef5c3d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a17dec08db66c71f11ebed2fe214aa9fcbbefef02f519906bc35c53351a784d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a17dec08db66c71f11ebed2fe214aa9fcbbefef02f519906bc35c53351a784d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a17dec08db66c71f11ebed2fe214aa9fcbbefef02f519906bc35c53351a784d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1bf2db440256681d338efce2c648c5086940f1c6701623c8abfb1bf05b81362"
    sha256 cellar: :any_skip_relocation, ventura:       "d1bf2db440256681d338efce2c648c5086940f1c6701623c8abfb1bf05b81362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a17dec08db66c71f11ebed2fe214aa9fcbbefef02f519906bc35c53351a784d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a17dec08db66c71f11ebed2fe214aa9fcbbefef02f519906bc35c53351a784d"
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