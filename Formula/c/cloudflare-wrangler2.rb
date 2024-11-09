class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.86.0.tgz"
  sha256 "217f58dd79f669aeede52d4aea2829d7bbd13665c7fb49f77e77ad035787ff3c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e4cab54ae2e3d3b2b45fab5ad158358d2942932b8593bb0c45f3649016fd3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4cab54ae2e3d3b2b45fab5ad158358d2942932b8593bb0c45f3649016fd3fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e4cab54ae2e3d3b2b45fab5ad158358d2942932b8593bb0c45f3649016fd3fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "665f169120660f45c13a8f855655379b6fc1735a7b6aa55e70098611e6e4b72b"
    sha256 cellar: :any_skip_relocation, ventura:       "665f169120660f45c13a8f855655379b6fc1735a7b6aa55e70098611e6e4b72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67eebeb1f72d182c6f0bee82d7cadbaa56454e2b9e94dc7d10147154936cd5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end