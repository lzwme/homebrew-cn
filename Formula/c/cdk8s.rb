class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.41.tgz"
  sha256 "3af885e5fe0bd96168db9b9a1e827ca637a54df68b6488fd98ac7152f7a2f9e4"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef9da5ff103263c7042324524a1f6cb5625fd4c48bd5ea23c559c3d7a6dc2f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef9da5ff103263c7042324524a1f6cb5625fd4c48bd5ea23c559c3d7a6dc2f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fef9da5ff103263c7042324524a1f6cb5625fd4c48bd5ea23c559c3d7a6dc2f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b6ac47672096a86e959a3a5f46658c74aad2b859c1b29361b480e2a5c4607b"
    sha256 cellar: :any_skip_relocation, ventura:       "97b6ac47672096a86e959a3a5f46658c74aad2b859c1b29361b480e2a5c4607b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fef9da5ff103263c7042324524a1f6cb5625fd4c48bd5ea23c559c3d7a6dc2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef9da5ff103263c7042324524a1f6cb5625fd4c48bd5ea23c559c3d7a6dc2f2"
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