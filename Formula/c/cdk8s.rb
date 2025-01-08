class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.293.tgz"
  sha256 "dbfa7c587677db4ce230c6b2141ccc19eb361d687e5946bb1b98c757ab003107"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f608502655335540dd1745d1134ebc0fe0c77cdccf02f2ff120b586b6a86f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f608502655335540dd1745d1134ebc0fe0c77cdccf02f2ff120b586b6a86f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f608502655335540dd1745d1134ebc0fe0c77cdccf02f2ff120b586b6a86f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab9b405698a5d5cf78faf67a5be59ed871e569825fe5cc756a0dd019ebf2bcc"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab9b405698a5d5cf78faf67a5be59ed871e569825fe5cc756a0dd019ebf2bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f608502655335540dd1745d1134ebc0fe0c77cdccf02f2ff120b586b6a86f04"
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