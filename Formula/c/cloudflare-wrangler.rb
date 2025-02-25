class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.109.3.tgz"
  sha256 "02535baa568960201a7ce54b48a74abf65f16a2a1b674c2dc7147950182b8af2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f9459f6626a5c4c617d7431edeb6007533ffe8e083d38ad6fff652321eae53e"
    sha256 cellar: :any,                 arm64_sonoma:  "0f9459f6626a5c4c617d7431edeb6007533ffe8e083d38ad6fff652321eae53e"
    sha256 cellar: :any,                 arm64_ventura: "0f9459f6626a5c4c617d7431edeb6007533ffe8e083d38ad6fff652321eae53e"
    sha256                               sonoma:        "1a433c2be386536c304b442967e151a87bd43d99429a88c94225077de580d945"
    sha256                               ventura:       "1a433c2be386536c304b442967e151a87bd43d99429a88c94225077de580d945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deebffce38e302321522300e24e6fd648192945c0e0e6296f6de56628e3e34e7"
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