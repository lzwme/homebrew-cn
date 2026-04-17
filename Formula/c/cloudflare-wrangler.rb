class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.83.0.tgz"
  sha256 "9f893404c302a2a42c7c9b39e017165554c4a9419b980cfee771bc895875962e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49a03fd4c86f5945f686abada0e78ecc3ef97df4c9caccaeb8cfd9c9a09566f8"
    sha256 cellar: :any,                 arm64_sequoia: "5a730635a0121431580601d710ff10b1046941b43526ce771722bb20068692ae"
    sha256 cellar: :any,                 arm64_sonoma:  "5a730635a0121431580601d710ff10b1046941b43526ce771722bb20068692ae"
    sha256 cellar: :any,                 sonoma:        "6c71aedc396c3d46511143615563965bded705691e0cc618ca375f6cb98cff73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab856bed181bbdce3d84e1a5c89b1643721bc0d13331d0eef55c4c6eb00c131a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "172b85152d8f76c62719b2d2714b1a8095fb175584a84cdada71a2a47bf18eb8"
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