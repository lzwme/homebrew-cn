class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.96.0.tgz"
  sha256 "e2e564687119753d4b96597a324a9a173b7c4ff79b25dc9723fd050a4e14ddf5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c42b7a324508e081434e9aa29919d23410b605b31b8758e4f045988fcb6f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c42b7a324508e081434e9aa29919d23410b605b31b8758e4f045988fcb6f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47c42b7a324508e081434e9aa29919d23410b605b31b8758e4f045988fcb6f26"
    sha256 cellar: :any_skip_relocation, sonoma:        "0caad71fd8105211571afebac69fb97b18182947e090bfe26252c2882387b15c"
    sha256 cellar: :any_skip_relocation, ventura:       "0caad71fd8105211571afebac69fb97b18182947e090bfe26252c2882387b15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097565c4716ee9868a712eb2b1c777a6208ea28ccea9d98e4cd60a6f470a3a0a"
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