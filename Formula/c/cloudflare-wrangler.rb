class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.90.0.tgz"
  sha256 "ff3ef014f6f409a62ddf5d2a89d60770982ae8836fcaf1d4617b80287c4e3743"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4259a5ad94d5f5b339e899f808e5fc5bc552ac18df721d55cefeb6d94a86035"
    sha256 cellar: :any,                 arm64_sequoia: "9b6ed43425a663aac201ed370ddfce567c61ee5256a80e5024d3070e4e679bbe"
    sha256 cellar: :any,                 arm64_sonoma:  "9b6ed43425a663aac201ed370ddfce567c61ee5256a80e5024d3070e4e679bbe"
    sha256 cellar: :any,                 sonoma:        "645c83c28708b186af48a02ba0499aa3588119bc5475fe45737e1e648e70fff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0075cdfb79c4f92272aa71c8144824c1321176d54c120e8d30f571f26bd6c21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fbff1d4c999c8bcd4ab091a335312fa628a57bb30b0fa2d6924a235b7cbe8f"
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