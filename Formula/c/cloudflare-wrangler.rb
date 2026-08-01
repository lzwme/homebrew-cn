class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.116.0.tgz"
  sha256 "90afa40f716bb2e02cc4cdb60cae2013b441cb1799a6b7b90aa48c74c209e572"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6ac2f4b562b64ab4eb92b5900a901ee8fd9093383c3760a111c00dda3214e8ec"
    sha256 cellar: :any, arm64_sequoia: "6ac2f4b562b64ab4eb92b5900a901ee8fd9093383c3760a111c00dda3214e8ec"
    sha256 cellar: :any, arm64_sonoma:  "6ac2f4b562b64ab4eb92b5900a901ee8fd9093383c3760a111c00dda3214e8ec"
    sha256 cellar: :any, sonoma:        "462d62fd40b3191b698c520e0d5d65be96507972a063ea9b7c3bcbd7d3c78a3c"
    sha256 cellar: :any, arm64_linux:   "304a069aa7d23b344f70e15c8725e6be6b112e146b68e82e99d9a2d0a8de6342"
    sha256 cellar: :any, x86_64_linux:  "07ce3a35384882f8c40eafa606fc69acd14cb553ae48ff3e3ee46e2da2d11594"
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