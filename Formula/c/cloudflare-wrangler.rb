class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.56.0.tgz"
  sha256 "c1045734faf8323e77b9f73a2b901757e4450988e8e004ec9ad90b49cc27228c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "741613bdf04f45576d68699874adae871c43a5669aa73d11ed8662e8d4170b45"
    sha256 cellar: :any,                 arm64_sequoia: "9202bd45f4405233b12d8b256890cfab63a7b2465f716cca5a8a13812e498f62"
    sha256 cellar: :any,                 arm64_sonoma:  "9202bd45f4405233b12d8b256890cfab63a7b2465f716cca5a8a13812e498f62"
    sha256 cellar: :any,                 sonoma:        "8a5f0aa0350642cae6f4655766259f1dfa3541efc895ccf27dd480da650269f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a24887e81162c04f7a7a8dff4c349386a1fad0e9eeb2b4d0ac33bbf5ea38d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e84cb13805e8f153d9d522a859ea6c7eeb66f59a96b6482e39252ee29b4127"
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