class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.202.tgz"
  sha256 "32dd3014a27f23f52d894c18ab612284be88ba6e8eb7c3552c349470fc9d66fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd9037e891f09385be3836833f61146de1bdc4abe44a6b0cc1dad61953bc086f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd9037e891f09385be3836833f61146de1bdc4abe44a6b0cc1dad61953bc086f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9037e891f09385be3836833f61146de1bdc4abe44a6b0cc1dad61953bc086f"
    sha256 cellar: :any_skip_relocation, sonoma:         "65edea442777f29f89e3c73698f53bc19ae37e0fe7469e16e0e0e71b18ebed2e"
    sha256 cellar: :any_skip_relocation, ventura:        "65edea442777f29f89e3c73698f53bc19ae37e0fe7469e16e0e0e71b18ebed2e"
    sha256 cellar: :any_skip_relocation, monterey:       "65edea442777f29f89e3c73698f53bc19ae37e0fe7469e16e0e0e71b18ebed2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd9037e891f09385be3836833f61146de1bdc4abe44a6b0cc1dad61953bc086f"
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