class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.58.0.tgz"
  sha256 "5f32207bc389879e6ff1a3eb43d9c867b4f6c6ac8fd91e3fec64d032e4423d8f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8eaba88214dfc474d7174fd69215e0d4e641aa08ad0282ae0524ddacf9247159"
    sha256 cellar: :any,                 arm64_sequoia: "d0f3f227602aee9aa403978acea7b2ac54633faf956a08664fb8238291c14da9"
    sha256 cellar: :any,                 arm64_sonoma:  "d0f3f227602aee9aa403978acea7b2ac54633faf956a08664fb8238291c14da9"
    sha256 cellar: :any,                 sonoma:        "329df57ce527e8ea21696cacfd96dd816151ae5658b0c91cd6b60d128a3ff43b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3cbdb766b45f7417b556a675a3f9d6274e3100f7e4a050697d5e2acdc185012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc86565ec1873a78fb93380b115c4e5d5bd917a650f6ee2b38590a67523e3f5"
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