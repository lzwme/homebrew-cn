class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.80.3.tgz"
  sha256 "d076451af2b53b3379e6c6d012f7a955236d0aeda82f83e3e9ccb952e03d5637"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38acfa20c4147daf8fb13ba8fc857cb44b93217684a0ea9d6964ead91b03888e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38acfa20c4147daf8fb13ba8fc857cb44b93217684a0ea9d6964ead91b03888e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38acfa20c4147daf8fb13ba8fc857cb44b93217684a0ea9d6964ead91b03888e"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f47e0849ee3ad016e2f2c7ce3ae9d6c9e012a8d060bd79b7993f708dac2212"
    sha256 cellar: :any_skip_relocation, ventura:       "18f47e0849ee3ad016e2f2c7ce3ae9d6c9e012a8d060bd79b7993f708dac2212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ed74360de14c6cd345d5d3b39ec820cd2461927402a23bf5d203306620bfbf"
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