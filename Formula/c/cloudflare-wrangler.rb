class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.145.0.tgz"
  sha256 "f9ae355a6c2af803ad5da07a6bcad2823abd151a1eea553da88a74c8cab159eb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fd8b6f33aa5c0dc62b51a0726ed0febc5c6bd7710ed5da2aeaa53e23d16a028a"
    sha256 cellar: :any, arm64_tahoe:       "fd8b6f33aa5c0dc62b51a0726ed0febc5c6bd7710ed5da2aeaa53e23d16a028a"
    sha256 cellar: :any, arm64_sequoia:     "fd8b6f33aa5c0dc62b51a0726ed0febc5c6bd7710ed5da2aeaa53e23d16a028a"
    sha256 cellar: :any, arm64_linux:       "69202e649efaee42c29431d49d933698f1a3222198cee5be1b715ec27fddef18"
    sha256 cellar: :any, x86_64_linux:      "afb980c135a7556bf10275b987a27d9c1d378aa05044709302b3cde68d66d971"
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