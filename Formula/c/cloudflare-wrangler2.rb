require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.15.0.tgz"
  sha256 "25a57b3c699fd2bf1560caa40ce136206506afd76489c9d12fe9f2dec0fc340b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8421017cbb5e22b400c25b4699bee6e82dde4fe7afffdceedbed0583a5e3579f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8421017cbb5e22b400c25b4699bee6e82dde4fe7afffdceedbed0583a5e3579f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8421017cbb5e22b400c25b4699bee6e82dde4fe7afffdceedbed0583a5e3579f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b8d5949ee90d1101b88ad079e9f15acc2d812a453d2fd238470ec11c9301a5f"
    sha256 cellar: :any_skip_relocation, ventura:        "8b8d5949ee90d1101b88ad079e9f15acc2d812a453d2fd238470ec11c9301a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "8b8d5949ee90d1101b88ad079e9f15acc2d812a453d2fd238470ec11c9301a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2168ca555407feb4915215ba329c88feb70fc738c35607c07aa131833e758480"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end