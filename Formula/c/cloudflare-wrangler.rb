class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.20.5.tgz"
  sha256 "d42526188dd6170953bcaca114cefc29033bde10e6bb2596c63e9ad5234f08ce"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03ccda80b06fadbbea1a1b48d8a2eeead4bb3afea7aa72c76fd5d34d87e1f4a4"
    sha256 cellar: :any,                 arm64_sonoma:  "03ccda80b06fadbbea1a1b48d8a2eeead4bb3afea7aa72c76fd5d34d87e1f4a4"
    sha256 cellar: :any,                 arm64_ventura: "03ccda80b06fadbbea1a1b48d8a2eeead4bb3afea7aa72c76fd5d34d87e1f4a4"
    sha256                               sonoma:        "9fe5a614da16251e8c2c218c41d0be288259b01b8e8e0630d56e0dfdb39bc85a"
    sha256                               ventura:       "9fe5a614da16251e8c2c218c41d0be288259b01b8e8e0630d56e0dfdb39bc85a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc7dbbb09ecc0e8e7b31fe82f00646957ed61f3b7cdb223085efc3d949ae93e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cddda95a8447b85a43c55791331ef54ad668aeb4f6d533c91962e2d8556b21f"
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