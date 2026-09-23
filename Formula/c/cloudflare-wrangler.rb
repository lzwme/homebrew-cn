class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.136.1.tgz"
  sha256 "1158de78c266b0e272e1acd6f40a4980edfac63cbceef698fefa32b699788a9d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3775ceb2f381e90570db64365cf1b2025a2e722dd75ce606f39cca6c266c109d"
    sha256 cellar: :any, arm64_tahoe:       "3775ceb2f381e90570db64365cf1b2025a2e722dd75ce606f39cca6c266c109d"
    sha256 cellar: :any, arm64_sequoia:     "3775ceb2f381e90570db64365cf1b2025a2e722dd75ce606f39cca6c266c109d"
    sha256 cellar: :any, arm64_linux:       "9559aef6a42edcddbd040bcb2e038928496e0ba40a797f0453cd82aea1bb929d"
    sha256 cellar: :any, x86_64_linux:      "64aee52851daac4df94fe65b9959501319aa7a3a8046c3b516c3cfec74eee3c6"
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