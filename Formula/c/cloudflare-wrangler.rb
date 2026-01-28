class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.61.0.tgz"
  sha256 "2525af3e71e343df6fcc1b2d2f6034ac60391517e1e5612cec7bdecf23ac73bb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b7db697d74c6289e34ff882e7dfbefdeffe999b18765292d13b4f8cfee46bec"
    sha256 cellar: :any,                 arm64_sequoia: "6d266c3256a4b7c82265aacb3b96013bcde249822a9c24d52ef424ac347da25a"
    sha256 cellar: :any,                 arm64_sonoma:  "6d266c3256a4b7c82265aacb3b96013bcde249822a9c24d52ef424ac347da25a"
    sha256 cellar: :any,                 sonoma:        "61604958cac786dea94c0d9e48b61067e811c019931ec87e8481d25eff067235"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bf5afbdf3b36de5ca793724d5131fad9c496904770e86e753494f5ed4768c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fecb04820281912407db4aef992acc79909aaec27b28531112d478ab14cf13c7"
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