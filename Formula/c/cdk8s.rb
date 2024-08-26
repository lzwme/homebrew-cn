class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.199.tgz"
  sha256 "8e0618f96b19c9ae55968ee929f8941979d05dc55c94b5815859b00a91089a20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cd2b4539b1a95c80d4cfd4b8fe22dfe853cf41895aebc4624990a39620eac5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cd2b4539b1a95c80d4cfd4b8fe22dfe853cf41895aebc4624990a39620eac5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd2b4539b1a95c80d4cfd4b8fe22dfe853cf41895aebc4624990a39620eac5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5835f03981ea662c598b1038755dbbaea4ca1a8d08509c15c0778c70f7a2950d"
    sha256 cellar: :any_skip_relocation, ventura:        "5835f03981ea662c598b1038755dbbaea4ca1a8d08509c15c0778c70f7a2950d"
    sha256 cellar: :any_skip_relocation, monterey:       "5835f03981ea662c598b1038755dbbaea4ca1a8d08509c15c0778c70f7a2950d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd2b4539b1a95c80d4cfd4b8fe22dfe853cf41895aebc4624990a39620eac5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end