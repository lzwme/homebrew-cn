class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.14.3.tgz"
  sha256 "69614607067fa46857cdca81cf38bf035cf5e78f0d10684a141522528691b962"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66bb24a9eb47e875f68f57c25e4f3189e7b6c9b20c8e622a0f448b1b13aff2ff"
    sha256 cellar: :any,                 arm64_sonoma:  "66bb24a9eb47e875f68f57c25e4f3189e7b6c9b20c8e622a0f448b1b13aff2ff"
    sha256 cellar: :any,                 arm64_ventura: "66bb24a9eb47e875f68f57c25e4f3189e7b6c9b20c8e622a0f448b1b13aff2ff"
    sha256                               sonoma:        "b322d9fb25521ee8362903b47ca980dc26354b61b120cd5ae25fc08995eb9dc4"
    sha256                               ventura:       "b322d9fb25521ee8362903b47ca980dc26354b61b120cd5ae25fc08995eb9dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "080f315e669859c03033a846d16774fa5244a89dce483e686e09e8a26e99781e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d079bc64dc1430ecc17042fdbd56853495cbb19c80cc725dc6b4f9b537467bb8"
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