class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.72.2.tgz"
  sha256 "bc59ed787f3caa09283e028629c68d24e701b5e5f1ffe722b85c3244b7ec23f0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a329280292e5174cb30757191f3cdd8cd308992ca85d14463722720558732c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a329280292e5174cb30757191f3cdd8cd308992ca85d14463722720558732c1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a329280292e5174cb30757191f3cdd8cd308992ca85d14463722720558732c1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "84ce05de3e20cd88d23b40fb5553421dfd5e0517f7b8fd3be743d36e3156af88"
    sha256 cellar: :any_skip_relocation, ventura:        "84ce05de3e20cd88d23b40fb5553421dfd5e0517f7b8fd3be743d36e3156af88"
    sha256 cellar: :any_skip_relocation, monterey:       "84ce05de3e20cd88d23b40fb5553421dfd5e0517f7b8fd3be743d36e3156af88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9438643019602c88f462c97cec2b47426a615bb9cf0fe0edb8156f4fae9024d1"
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