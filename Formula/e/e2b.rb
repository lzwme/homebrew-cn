class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.9.2.tgz"
  sha256 "5f2a167d7c7d18a9ae51d45366d2160698b179f5b4d63e48c8be732351ca3b26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "389a7740a3be2807697ee57b30760c0fa1d079b6307342126875d762acefcb7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "389a7740a3be2807697ee57b30760c0fa1d079b6307342126875d762acefcb7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "389a7740a3be2807697ee57b30760c0fa1d079b6307342126875d762acefcb7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd699ace4761d87d742a88c7c9d3a9d7894b161dc90f8652521567714590e534"
    sha256 cellar: :any_skip_relocation, ventura:       "dd699ace4761d87d742a88c7c9d3a9d7894b161dc90f8652521567714590e534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389a7740a3be2807697ee57b30760c0fa1d079b6307342126875d762acefcb7f"
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