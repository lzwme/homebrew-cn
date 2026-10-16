class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.151.0.tgz"
  sha256 "e14ed5fd78db64dc0ce684f823596a897e08223a0190eaff53b5bafdb8cb8969"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62015a8b6fac6290ad52e982acca6ca44c7d7e43f24261f991a4bd801d09cde8"
    sha256 cellar: :any, arm64_tahoe:       "62015a8b6fac6290ad52e982acca6ca44c7d7e43f24261f991a4bd801d09cde8"
    sha256 cellar: :any, arm64_sequoia:     "62015a8b6fac6290ad52e982acca6ca44c7d7e43f24261f991a4bd801d09cde8"
    sha256 cellar: :any, arm64_linux:       "41708309a3522334ea32de334cdf0a055efcd255ac592b48c145abbad9f334b6"
    sha256 cellar: :any, x86_64_linux:      "cb621eeab1bc31b327a3c4e74f6006a415a6ef3f81202274cab09e049fb0c331"
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