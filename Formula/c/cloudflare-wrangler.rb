class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.131.1.tgz"
  sha256 "1b0863093d9caa36a8c5937ff35461a3ea13be32c3d1395ea909f363b7db0f19"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1652db2d199cfde531c61198506eda567ea97a77c89a9936056f7056d96a02d"
    sha256 cellar: :any, arm64_tahoe:       "a1652db2d199cfde531c61198506eda567ea97a77c89a9936056f7056d96a02d"
    sha256 cellar: :any, arm64_sequoia:     "a1652db2d199cfde531c61198506eda567ea97a77c89a9936056f7056d96a02d"
    sha256 cellar: :any, arm64_linux:       "a575d98e4b71469d25a8f77cc96c34cd7ebfadb6e43c0311caae3ffdbad35984"
    sha256 cellar: :any, x86_64_linux:      "98b96493ec93e7ff82887fb27ff6cd0050dc50cab5a6ba4f49f0f26c89bde706"
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