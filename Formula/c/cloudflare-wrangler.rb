class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.149.0.tgz"
  sha256 "08b38c62bcaad1c1722ca1b811a41daac0faffcbbe0ab5825f993da1d2920f3c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7cd88f60a507216b65b154e84793815a6944c70213b7ec97087658fbbfae2196"
    sha256 cellar: :any, arm64_tahoe:       "7cd88f60a507216b65b154e84793815a6944c70213b7ec97087658fbbfae2196"
    sha256 cellar: :any, arm64_sequoia:     "7cd88f60a507216b65b154e84793815a6944c70213b7ec97087658fbbfae2196"
    sha256 cellar: :any, arm64_linux:       "5ee457ae8c65d07b01c71954b802fdd1fd1d70b78d4f1b347f5d3e50a8368530"
    sha256 cellar: :any, x86_64_linux:      "94903de2e3a17281f2ae224cc606c7eb21ce8d1363cb9f971769e994eeaaf14d"
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