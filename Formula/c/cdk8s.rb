require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.127.tgz"
  sha256 "47c4f88b126d36ddc331fd88005eb593a6dcad8082c46b30a3f32f98d06e4de0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd7f5bbb28140c4595d2256293787c906d9fe5148c9ede5b13820023533ce92d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d89a55c501d7bea99f8320b43572b85203db532acbabc572c72e40b8130e5847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c55dfe753463029311a90e7508a71cad71bd24a0d6e0128bdd96e79d175372"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a9d5381fe6bac980c1d9f20d7f78f211e03519a19856fb6b178a2db1bb57245"
    sha256 cellar: :any_skip_relocation, ventura:        "c9caf48b3c98e28d7892d529266ec009e362dc2164d6cc40fca683635e589e24"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2bac3b9e49c01d25785f4e632e506c1642d271c9de1a159f45fff43b2a6d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63057787760f779cfdda969715a04828984d3bf3cc494be79785735b43ec10ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end