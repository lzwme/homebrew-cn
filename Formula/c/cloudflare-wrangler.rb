class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.52.0.tgz"
  sha256 "438d2b5004bd7cda074462434e583252252739798856daf0b396c6eccffda16a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a30376020bda7517b4e1f62e939866290ea18a8480c11680b39241891d6e7951"
    sha256 cellar: :any,                 arm64_sequoia: "eb770dccf3d0908f67833f1c7c62236a02668747c41a05fe6eddaa689300c74d"
    sha256 cellar: :any,                 arm64_sonoma:  "eb770dccf3d0908f67833f1c7c62236a02668747c41a05fe6eddaa689300c74d"
    sha256 cellar: :any,                 sonoma:        "36d02186bd743b457e4dbe91c5f6b2748501441edb6b95bbc364f299e73c3b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b476116ea7196f4fad665fb4613bd615f4c160630ac3612331a0331eae87caee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c3d989fe9cdefb255ace37a26dd233795af0a0a83dbf64b2af48a118fe9cdd"
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