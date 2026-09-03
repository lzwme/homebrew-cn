class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.128.0.tgz"
  sha256 "2a9f626e96c965daed53b098fb1998a56c600f627236a8b7428756715051964d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "504e209df8b4ff8122d3390ef8a5c913ac23248c6baabca3d018aa755bad1552"
    sha256 cellar: :any, arm64_sequoia: "504e209df8b4ff8122d3390ef8a5c913ac23248c6baabca3d018aa755bad1552"
    sha256 cellar: :any, arm64_sonoma:  "504e209df8b4ff8122d3390ef8a5c913ac23248c6baabca3d018aa755bad1552"
    sha256 cellar: :any, arm64_linux:   "57b687ba5ec049aa380f6fb4df73da1a1924bef637b5cfcb2006b698a86a2f9f"
    sha256 cellar: :any, x86_64_linux:  "5653543bb0996d558bcd41f6ee39632d4bbf79dfcf12d47d136871b0a71f4e4c"
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