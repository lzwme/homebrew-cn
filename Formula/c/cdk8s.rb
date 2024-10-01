class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.232.tgz"
  sha256 "4b4642cd45986a2e0725fae113d5fdd26c87694fc54bac36b5241d48427378eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd106dac472c37f4bc1b46877b4f3def2737acc6293c0f688d39982e64bbd5ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd106dac472c37f4bc1b46877b4f3def2737acc6293c0f688d39982e64bbd5ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd106dac472c37f4bc1b46877b4f3def2737acc6293c0f688d39982e64bbd5ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda107d82a92ed41713458f2adde6f0834c0f1d8f5df2671418bfa047fba3fb8"
    sha256 cellar: :any_skip_relocation, ventura:       "bda107d82a92ed41713458f2adde6f0834c0f1d8f5df2671418bfa047fba3fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd106dac472c37f4bc1b46877b4f3def2737acc6293c0f688d39982e64bbd5ea"
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