class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.46.0.tgz"
  sha256 "bf992857b198ddeaa8888f08c9619605dddae81bf733362487037878b475028e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f2ded98c7dfec3ffad5471da271e518c1d292f7599e7372825db8fffe161ebb"
    sha256 cellar: :any,                 arm64_sequoia: "f51b2626cdb91790c4d503654d41bc23e220c0ddbf1fe244f083bbf89744704c"
    sha256 cellar: :any,                 arm64_sonoma:  "f51b2626cdb91790c4d503654d41bc23e220c0ddbf1fe244f083bbf89744704c"
    sha256 cellar: :any,                 sonoma:        "5035e5007e017837bf589ed5ad7a7ec0434d4f5e18f94e69a3b93d24e933b454"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6ad82424c9063c3afce33e024dfa299dcaea12bb75ffdabe5d6ae199d03c786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53753edbc5531fd208f0c8cd17192239494b44f692b170e2d7642428a44c7380"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end