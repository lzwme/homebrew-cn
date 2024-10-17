class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.80.5.tgz"
  sha256 "5790d365f5aba3e0c2ce7aff2c39c64ad0ff473682ba4fe9a2b36e6982b52a6b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f378889a335e9751c0afef3736b77770209ae04088dd740c122979c909dd78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f378889a335e9751c0afef3736b77770209ae04088dd740c122979c909dd78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0f378889a335e9751c0afef3736b77770209ae04088dd740c122979c909dd78"
    sha256 cellar: :any_skip_relocation, sonoma:        "a27093670aedf2a17244747d4c25c90111a2a3f03c412f6ae8d3fe060d9c8c60"
    sha256 cellar: :any_skip_relocation, ventura:       "a27093670aedf2a17244747d4c25c90111a2a3f03c412f6ae8d3fe060d9c8c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec08d342a22247af474fcc2d63a66bb49594805521f44a3e51b05b0023a2e35"
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