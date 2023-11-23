require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.17.1.tgz"
  sha256 "4e8dfddb41707e99494a7510452767547475021695bdf5247c094ba9aa7d82b6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb04c8dc7ce62b984a64488bcc99401f2b3e1e6ea6d991dd2fc16d52b8068f3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb04c8dc7ce62b984a64488bcc99401f2b3e1e6ea6d991dd2fc16d52b8068f3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb04c8dc7ce62b984a64488bcc99401f2b3e1e6ea6d991dd2fc16d52b8068f3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "69f99294d05578b9d0245df47640ebbfe344d191674495d4f9de75e33e0f0257"
    sha256 cellar: :any_skip_relocation, ventura:        "69f99294d05578b9d0245df47640ebbfe344d191674495d4f9de75e33e0f0257"
    sha256 cellar: :any_skip_relocation, monterey:       "69f99294d05578b9d0245df47640ebbfe344d191674495d4f9de75e33e0f0257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6c6529014a3033787750595249311d460b4c08405e4cc8a218ec258af19691"
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