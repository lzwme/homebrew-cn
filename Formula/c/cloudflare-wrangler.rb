class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.144.0.tgz"
  sha256 "81fe9a991e9fb57ccf8eb7f6378a25ae02c7de1699ae53632f96c6fe85d45511"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b83729a9813d71cf4886ed5f571063d1c02d714cb9533d4fbc46f9cd70218eb"
    sha256 cellar: :any, arm64_tahoe:       "6b83729a9813d71cf4886ed5f571063d1c02d714cb9533d4fbc46f9cd70218eb"
    sha256 cellar: :any, arm64_sequoia:     "6b83729a9813d71cf4886ed5f571063d1c02d714cb9533d4fbc46f9cd70218eb"
    sha256 cellar: :any, arm64_linux:       "f80a36a6a7777e903bdff1ce0e27285b6b784886b9057b6606256ec04a0f2bee"
    sha256 cellar: :any, x86_64_linux:      "2aa790bf61a0da25814631f4b4f734d5c48a5cc5a75835daf44e0a2e26916d9a"
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