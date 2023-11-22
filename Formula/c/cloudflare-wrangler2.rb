require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.17.0.tgz"
  sha256 "098f3a75c429c719afa1f0b38b00520c325b17ed0196e03776fd049451fbe9ca"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f813343aaacdd38d7a5aa611af8e7a507436300b374177a6d19aa98de874ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f813343aaacdd38d7a5aa611af8e7a507436300b374177a6d19aa98de874ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f813343aaacdd38d7a5aa611af8e7a507436300b374177a6d19aa98de874ea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac8568740250e9cfb8ee1f0f149b7feed458be30ceb2ecfb5927c8e18bb984f9"
    sha256 cellar: :any_skip_relocation, ventura:        "ac8568740250e9cfb8ee1f0f149b7feed458be30ceb2ecfb5927c8e18bb984f9"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8568740250e9cfb8ee1f0f149b7feed458be30ceb2ecfb5927c8e18bb984f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84067d45df32e64719fccea22904b4d68dde40efbfb5ec3a3ecfb11afa10bd50"
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