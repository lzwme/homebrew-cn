class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.127.0.tgz"
  sha256 "ca526a90e12ea8f30413cbdbff55f55ea22984ef222dfb51857f2141a57972ef"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d6fa7c6cf245b578f399e868df9a2795f60ca8da5704d0b6c7028e40f1327f4"
    sha256 cellar: :any, arm64_sequoia: "7d6fa7c6cf245b578f399e868df9a2795f60ca8da5704d0b6c7028e40f1327f4"
    sha256 cellar: :any, arm64_sonoma:  "7d6fa7c6cf245b578f399e868df9a2795f60ca8da5704d0b6c7028e40f1327f4"
    sha256 cellar: :any, arm64_linux:   "fe897189953e1ec798a74e147424235e8ce2e60a93a2ab96bae50ddbae8aba09"
    sha256 cellar: :any, x86_64_linux:  "556436d959f50fa8323759655e3242640845cdff107e44f93263aa1e8d5f9761"
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