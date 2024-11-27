class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.91.0.tgz"
  sha256 "cca219fd6869165a03b396696ed554333dd099522c62e96dd0cdb25af6e2295e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5010022ac9895e3af403e009a615b098c15a5aca6db68117168915e77fecce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5010022ac9895e3af403e009a615b098c15a5aca6db68117168915e77fecce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5010022ac9895e3af403e009a615b098c15a5aca6db68117168915e77fecce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "88b5e2bb6381a3b9580f5fca3f3dc5e4399e94ef621148d9020ff85c77e10566"
    sha256 cellar: :any_skip_relocation, ventura:       "88b5e2bb6381a3b9580f5fca3f3dc5e4399e94ef621148d9020ff85c77e10566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd088af2a162fd9ad93d8ae467a62ff6c7aed60b78871d9ab2e5f89469adb503"
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