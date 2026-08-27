class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.126.0.tgz"
  sha256 "1a7a8a8553032ae4aea089cff752317c6c9fd842b6e5a83f2ff7f182cb117b8e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d0054534044ce37bad5bf623a8a3774aafe5b743309109e6fead42ce301e417"
    sha256 cellar: :any, arm64_sequoia: "0d0054534044ce37bad5bf623a8a3774aafe5b743309109e6fead42ce301e417"
    sha256 cellar: :any, arm64_sonoma:  "0d0054534044ce37bad5bf623a8a3774aafe5b743309109e6fead42ce301e417"
    sha256 cellar: :any, sonoma:        "9927fe65344b19d4d126c3aaf25f6a99d09f01bc00328b8414d19cbd79153fb3"
    sha256 cellar: :any, arm64_linux:   "852d2a50b11cfd982c9314a021fada595ff5bb0a6378b10c7a972d296d1802d3"
    sha256 cellar: :any, x86_64_linux:  "4c85aa4e6b3f38aefa278682b0dd67534eb2e6fee6b21c20c7c0ee01ebd21da8"
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