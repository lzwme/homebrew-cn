class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.100.0.tgz"
  sha256 "5a437fecd9c794d8279aa2a84d1a977ffe747e8a4e628575b0e07af54e0637c1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "66edf214e6744d30f118fbf3c3734d9bd77d0cf0755b702837b14a367080d440"
    sha256 cellar: :any, arm64_sequoia: "cfc41f9b9b1e39d5471c529866f9e4ddfbf7923b67b589ba791ac5f8f63c8bdd"
    sha256 cellar: :any, arm64_sonoma:  "cfc41f9b9b1e39d5471c529866f9e4ddfbf7923b67b589ba791ac5f8f63c8bdd"
    sha256 cellar: :any, sonoma:        "a9a8683fbd93a0a03ed179639ee4f3bc826e051b4df3f3a782dc2d637e918f52"
    sha256 cellar: :any, arm64_linux:   "a5670bfcfc182f9b92aea6f70118c7fdcd499bfd7700a16215c34e28d2a48856"
    sha256 cellar: :any, x86_64_linux:  "d87867b1db9dd47a70e4af746bbe01f5dc691decf0fc0d22979a174b5c3f9fed"
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