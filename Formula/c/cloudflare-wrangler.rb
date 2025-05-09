class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.14.4.tgz"
  sha256 "d5cfbfe958e486b0c18a51d534e53475953164cff74ebccde1231ff71284a36c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a844164b4e55c04e6bbf24cd274075969a65edfd2c3e7a0f53558ae09318573"
    sha256 cellar: :any,                 arm64_sonoma:  "1a844164b4e55c04e6bbf24cd274075969a65edfd2c3e7a0f53558ae09318573"
    sha256 cellar: :any,                 arm64_ventura: "1a844164b4e55c04e6bbf24cd274075969a65edfd2c3e7a0f53558ae09318573"
    sha256                               sonoma:        "08fc9980984266ef1ecbe7e023ce5675977f0765fbcb9d7bfc33b2f9e06b4a2a"
    sha256                               ventura:       "08fc9980984266ef1ecbe7e023ce5675977f0765fbcb9d7bfc33b2f9e06b4a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "986c7917a335cd72a3cb386aba42f48aebccff6f6c380dadc90541ebe5a7dcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867a665eb319df8c02b827c14f82ebdd07ded40d5de9a4352e179810fb9a9c9f"
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