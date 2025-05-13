class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.3.4.tgz"
  sha256 "ce969bfe26cb27a8c2bfdcc1391ab80d734a8706a339aa2a0f840080564472f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0b533b12488e56a9dfdeee3da7e4615f02dd4395d707bde7b59fb4e8d1299f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0b533b12488e56a9dfdeee3da7e4615f02dd4395d707bde7b59fb4e8d1299f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d0b533b12488e56a9dfdeee3da7e4615f02dd4395d707bde7b59fb4e8d1299f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbf5e66ea9b8839c89dfaf5d50a8eb6d4e415661e0369c3d3eaaf9c7efeaf401"
    sha256 cellar: :any_skip_relocation, ventura:       "fbf5e66ea9b8839c89dfaf5d50a8eb6d4e415661e0369c3d3eaaf9c7efeaf401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0b533b12488e56a9dfdeee3da7e4615f02dd4395d707bde7b59fb4e8d1299f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end