class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.8.0.tgz"
  sha256 "ec82e12a7607b7bcf735f97f29eb8f8db3aaffb8a1dd2e041d0219142768a5eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5671875a993316f21ffdeb71733d47340ea0d1fd1953e9b18cf1926c8606aa36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5671875a993316f21ffdeb71733d47340ea0d1fd1953e9b18cf1926c8606aa36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5671875a993316f21ffdeb71733d47340ea0d1fd1953e9b18cf1926c8606aa36"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf85821a61756f909e8675885ce55b1a8023fede23337c48590a5e174b8f8cf6"
    sha256 cellar: :any_skip_relocation, ventura:       "cf85821a61756f909e8675885ce55b1a8023fede23337c48590a5e174b8f8cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5671875a993316f21ffdeb71733d47340ea0d1fd1953e9b18cf1926c8606aa36"
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