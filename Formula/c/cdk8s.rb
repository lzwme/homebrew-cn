class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.304.tgz"
  sha256 "17a817624e35287f65f50fd0f9377c07451ebb7bfb0d79412bc6dffe69405aa4"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f0301cffa3c052655fa35f7c460d6381f46b61116770c50f1d2b0a3c30fc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f0301cffa3c052655fa35f7c460d6381f46b61116770c50f1d2b0a3c30fc7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91f0301cffa3c052655fa35f7c460d6381f46b61116770c50f1d2b0a3c30fc7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "09dd0bc0128930f0ccfa8cb929149b14ec8ea8d887de9c11553d275755c4216e"
    sha256 cellar: :any_skip_relocation, ventura:       "09dd0bc0128930f0ccfa8cb929149b14ec8ea8d887de9c11553d275755c4216e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f0301cffa3c052655fa35f7c460d6381f46b61116770c50f1d2b0a3c30fc7a"
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