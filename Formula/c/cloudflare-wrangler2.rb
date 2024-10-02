class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.79.0.tgz"
  sha256 "2780bc8d69c5aa84b0304511dde85ba140cbf9ac1b4b78e51fb33afbba65e58c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9896295e159ae20fefdc2e5dd8fcf0b9c5fe660f82e6cca54ef281eea0d7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c9896295e159ae20fefdc2e5dd8fcf0b9c5fe660f82e6cca54ef281eea0d7f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c9896295e159ae20fefdc2e5dd8fcf0b9c5fe660f82e6cca54ef281eea0d7f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "536bfa8ef7cc43355a7615e4196a20ed68c4ca1b9e4a909ba722cd3fd3925afc"
    sha256 cellar: :any_skip_relocation, ventura:       "536bfa8ef7cc43355a7615e4196a20ed68c4ca1b9e4a909ba722cd3fd3925afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88571a71a45fd6760bd88cdd4801f5307abbba741d12c7286ef5a4572b1e834c"
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