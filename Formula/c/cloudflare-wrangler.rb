class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.41.0.tgz"
  sha256 "b9a2f2e34ceb6437fc3f4d9013d188868606b257611e82fb950a87e218a4c36d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb987d9cbe1e591df387af11e08dad0cf016c158cda70888501a2f0091c9aaca"
    sha256 cellar: :any,                 arm64_sequoia: "01af5aedd0d466a1e519ad8ef115dad8f0e0ac07f1df14f1867491c317ace875"
    sha256 cellar: :any,                 arm64_sonoma:  "01af5aedd0d466a1e519ad8ef115dad8f0e0ac07f1df14f1867491c317ace875"
    sha256 cellar: :any,                 sonoma:        "8c6eab777fc74321ab9e2a81877af9e202143f7927f67b4b38bbf6b5a9bc4795"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88f3f810d13afbb6ff6b858c889251c102f4b03ba0313f54f30bc246c7d0141e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac1c5c2387f5d5543bd45b386eb02a7579b65f8a745fc22da76501c04e33ace"
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