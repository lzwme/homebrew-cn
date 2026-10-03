class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.146.0.tgz"
  sha256 "e6ad9c61546aea21779a92da3b7eae9fb228fcbde80c203fe3a78417b8530132"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0c3698086153f05c948fe32d8e974eb03391562b2619e4b287da5902fe1245af"
    sha256 cellar: :any, arm64_tahoe:       "0c3698086153f05c948fe32d8e974eb03391562b2619e4b287da5902fe1245af"
    sha256 cellar: :any, arm64_sequoia:     "0c3698086153f05c948fe32d8e974eb03391562b2619e4b287da5902fe1245af"
    sha256 cellar: :any, arm64_linux:       "d8498b949f5ad260af67f38220d4f06ef88b551b252e587b5414459a65f84f92"
    sha256 cellar: :any, x86_64_linux:      "c019a332453dbee2666dbca123e127991cba52935a6d3d44c609cea7e2778bcd"
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