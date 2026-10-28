class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.153.0.tgz"
  sha256 "7be2d2f2cdf657f7d24833101e4e3ec560873dcc02c3800f5a2a8c8e3ba52448"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f711227b84d7b9a9530f1f27029fcfaa232969e9ee07c9fbec31d67485aa279b"
    sha256 cellar: :any, arm64_tahoe:       "f711227b84d7b9a9530f1f27029fcfaa232969e9ee07c9fbec31d67485aa279b"
    sha256 cellar: :any, arm64_sequoia:     "f711227b84d7b9a9530f1f27029fcfaa232969e9ee07c9fbec31d67485aa279b"
    sha256 cellar: :any, arm64_linux:       "56cbe2a7c27dd93458f8a4926f0f33ec2c82d08978cb4823b156e82ba094fb1b"
    sha256 cellar: :any, x86_64_linux:      "7ff4777f1195a4ec8b5cd0d368c65b114398736904a8dfd60a34faaa30b8ff7c"
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