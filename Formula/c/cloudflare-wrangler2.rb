class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.73.0.tgz"
  sha256 "822719d048c274da810d2b9701a27b648ac555da1f97e2b67c28c68f6c3b7862"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e027130194498645480ad7dc75c544e55c9aad2f70199c70bd1ca17fe978432"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e027130194498645480ad7dc75c544e55c9aad2f70199c70bd1ca17fe978432"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e027130194498645480ad7dc75c544e55c9aad2f70199c70bd1ca17fe978432"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ce740ea21b8dac1c1cb72bc99db27ef27a0f0d3272c84f9877fac58cbf00236"
    sha256 cellar: :any_skip_relocation, ventura:        "6ce740ea21b8dac1c1cb72bc99db27ef27a0f0d3272c84f9877fac58cbf00236"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce740ea21b8dac1c1cb72bc99db27ef27a0f0d3272c84f9877fac58cbf00236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a3457e10495c88428ff1670d46d1db7a19448afab0cc5cb99d9bab34e9070fb"
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