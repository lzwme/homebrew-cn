class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.131.2.tgz"
  sha256 "860de8935336155ef7ac5ee91aeec78701edca4adb6987d4af6c41c1ea5c72b0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f92e3c2ca88f31e5e0c1a5fbbe4af3de3a8ee978f0d16c1a1f0c74b4461b896"
    sha256 cellar: :any, arm64_tahoe:       "6f92e3c2ca88f31e5e0c1a5fbbe4af3de3a8ee978f0d16c1a1f0c74b4461b896"
    sha256 cellar: :any, arm64_sequoia:     "6f92e3c2ca88f31e5e0c1a5fbbe4af3de3a8ee978f0d16c1a1f0c74b4461b896"
    sha256 cellar: :any, arm64_linux:       "3021558004b419437058eecb39ec8625893899ef522b89eae8a421edd00037dd"
    sha256 cellar: :any, x86_64_linux:      "f86aaa36af1596ed70fdd6eb486e31916c2ca0829d4292237d78ef790ee728da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end