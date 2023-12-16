require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.21.0.tgz"
  sha256 "bca38f389b5df094a16454564013d5c571bb59f46147324a1d6a33a3dd2e2240"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdce7d92a54ab02510c950c2d1ea38cfe12222fe30732f8a23493efe1bef3ce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdce7d92a54ab02510c950c2d1ea38cfe12222fe30732f8a23493efe1bef3ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdce7d92a54ab02510c950c2d1ea38cfe12222fe30732f8a23493efe1bef3ce4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2cce1c83f9ef2f31e85a4a6e6beeecfea43bf1f15093eb57746158d4b83cb52"
    sha256 cellar: :any_skip_relocation, ventura:        "c2cce1c83f9ef2f31e85a4a6e6beeecfea43bf1f15093eb57746158d4b83cb52"
    sha256 cellar: :any_skip_relocation, monterey:       "c2cce1c83f9ef2f31e85a4a6e6beeecfea43bf1f15093eb57746158d4b83cb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4f5934269f0cd9d0010009fae6a1380d7edb96a9d2774fbb0b208741d335a6"
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