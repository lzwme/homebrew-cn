class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.68.1.tgz"
  sha256 "f2e7f67ae4097644dc8e844dcd89a6fd472d8f81b204bb74b4ed70be7bc66993"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9aae761724af4f0e7a2ab203757546b00e2e26a91dee986b8cf0b0bbe862156"
    sha256 cellar: :any,                 arm64_sequoia: "8b49ed6d80784531ece1a5fb36d75beb17801107d173ffd6b92fd3f5c9db0666"
    sha256 cellar: :any,                 arm64_sonoma:  "8b49ed6d80784531ece1a5fb36d75beb17801107d173ffd6b92fd3f5c9db0666"
    sha256 cellar: :any,                 sonoma:        "ab2ebbc0e475b37f96600685db8230fb7b39f1e9c8daf568c7268a4ca00e88bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47091438a7bb6503a86ddc440325bc14019e5c39db451774631e9da51addef36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5879cc269fdffbd730981fe42206f78b631746990f04a7399177a5e4aad9bee9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end