class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.118.0.tgz"
  sha256 "e1c75e298aec20667f627ed4a838bbeef1850754e061aaf8fc6611aff522d4cf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ad3965683d41e720b24a76ce88e14b82be2d67f1ee5405bd7300c25fe575719a"
    sha256 cellar: :any, arm64_sequoia: "ad3965683d41e720b24a76ce88e14b82be2d67f1ee5405bd7300c25fe575719a"
    sha256 cellar: :any, arm64_sonoma:  "ad3965683d41e720b24a76ce88e14b82be2d67f1ee5405bd7300c25fe575719a"
    sha256 cellar: :any, sonoma:        "02ad6aaa73e47fd8eb41414c9a7bc6379f20d5532be59f11755573ec87bd7267"
    sha256 cellar: :any, arm64_linux:   "9bb32185c989c0cb9d5d473709ed4b64c1e4c33c6b8ef2e7baf181185ed573db"
    sha256 cellar: :any, x86_64_linux:  "e806dd20f64bbbf93d243309b28d3d96fc6794dc0708ac0fc6db3461661da243"
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