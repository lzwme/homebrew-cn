class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.101.0.tgz"
  sha256 "8f6039d36d367bb59ad042229e2ebc2d99149f67db254efa208b8722096bc6fe"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd66b555726fe0da2bd3c52b175423ee9c1e7bccf0d6ab637de8323e1401e9ce"
    sha256 cellar: :any, arm64_sequoia: "052fbfa9a9d1f377a7cd53713ab677b6c3989c509d495b02deccbfed93997ef7"
    sha256 cellar: :any, arm64_sonoma:  "052fbfa9a9d1f377a7cd53713ab677b6c3989c509d495b02deccbfed93997ef7"
    sha256 cellar: :any, sonoma:        "b0786cfe8072f798c3aced0b289417f22065e7676a23fc8f5586e8e62313fa48"
    sha256 cellar: :any, arm64_linux:   "2652bae06cd3ce694530270f157551ca18f7b94183e8f77791395f97f588fb4b"
    sha256 cellar: :any, x86_64_linux:  "953baf1d1d9f9f42664c4150f05855742bee0614d7bb504d5dd79610cabdd031"
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