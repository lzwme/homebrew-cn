class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.15.2.tgz"
  sha256 "66548ce6af18f898258496be306c4a769e69aa7cf0ee954fc586d1027ba67749"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "681b179918dbf1e06690c305a50d36046beb9c5a1f2f831bdcb554815225ed9d"
    sha256 cellar: :any,                 arm64_sonoma:  "681b179918dbf1e06690c305a50d36046beb9c5a1f2f831bdcb554815225ed9d"
    sha256 cellar: :any,                 arm64_ventura: "681b179918dbf1e06690c305a50d36046beb9c5a1f2f831bdcb554815225ed9d"
    sha256                               sonoma:        "573211fee0fec2a960ad367d7800da8b259fb64055492ddde949d10c9b3935ac"
    sha256                               ventura:       "573211fee0fec2a960ad367d7800da8b259fb64055492ddde949d10c9b3935ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b626809d065175895a4ba6d5b204bf22ed9505bc00c5b952b8c628019c352bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae6224c4078cc29df701ad97fb1c7c6699ac0358358cedda83c0dc7a451ea93"
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