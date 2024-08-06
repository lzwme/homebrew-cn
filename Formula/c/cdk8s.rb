class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.180.tgz"
  sha256 "7ee2ab3952551041e26e308b59dc94b459fb82b19b7b18d0af79f52ea68f2a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4094f7798b36d67af13309f3869cd16af75a4125a315aa36d9ab9e03b604ef3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4094f7798b36d67af13309f3869cd16af75a4125a315aa36d9ab9e03b604ef3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4094f7798b36d67af13309f3869cd16af75a4125a315aa36d9ab9e03b604ef3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a56ec49fb9ab62df33ab656704b36779008d6ff531ac6873a58c9618429672d"
    sha256 cellar: :any_skip_relocation, ventura:        "3a56ec49fb9ab62df33ab656704b36779008d6ff531ac6873a58c9618429672d"
    sha256 cellar: :any_skip_relocation, monterey:       "3a56ec49fb9ab62df33ab656704b36779008d6ff531ac6873a58c9618429672d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4094f7798b36d67af13309f3869cd16af75a4125a315aa36d9ab9e03b604ef3c"
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