class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.119.0.tgz"
  sha256 "8c8466e4093a535cb8076c8f6355bc107aac27b8220a602501a16dbc5afebacf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61b6ccaf41c4bfc10581928c11f030c1eedc29bb001ecc6464fb28bb759dd9f8"
    sha256 cellar: :any, arm64_sequoia: "61b6ccaf41c4bfc10581928c11f030c1eedc29bb001ecc6464fb28bb759dd9f8"
    sha256 cellar: :any, arm64_sonoma:  "61b6ccaf41c4bfc10581928c11f030c1eedc29bb001ecc6464fb28bb759dd9f8"
    sha256 cellar: :any, sonoma:        "41a6b39d9a79375f6c663bf517af333b654de6d6e7fbc93e79c0bf4901644ccf"
    sha256 cellar: :any, arm64_linux:   "6f655b6c237cb775bc316214ba0526dfce49d18bc4a7e482ef505d8143a2fc15"
    sha256 cellar: :any, x86_64_linux:  "74ae6bfa479adbb25c5d90a9e309bdabbfa200a4b6f7c7ef199c6e32273f14e2"
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