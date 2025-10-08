class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.42.1.tgz"
  sha256 "2e3d3754ed2de5425a2e32ed4d6f07d7bfbe8daef64f5d36a0d9655324c16a06"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d14fbdfc8266575518f5d9f1f54e9dcbe0826fc0638aa88b387e84b0af4a3e5"
    sha256 cellar: :any,                 arm64_sequoia: "34d205a2f12ce92928b3cea1c3462e2eb392308113914dc0b3fb900bb0b3ef69"
    sha256 cellar: :any,                 arm64_sonoma:  "34d205a2f12ce92928b3cea1c3462e2eb392308113914dc0b3fb900bb0b3ef69"
    sha256 cellar: :any,                 sonoma:        "580b69c6f26573be6de1ef42d57017e22eed964a581e8f6cc4446b55d03943ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc1b52c093abe8cfc1cdd22429581e6facf3fbc625a5ba665daf56c6fa08be74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a47afa744ce108dad2764e3f601b4bb8e71fa924522d41b58b0d03b4dafd8c"
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