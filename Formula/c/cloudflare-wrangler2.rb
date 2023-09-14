require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.8.0.tgz"
  sha256 "1c69a5f50dd1ed550b8443f2b28de545588378a0161a204103cfef04223814ea"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50bace51656209d66a79f4331230f2d326bfa4aef6d849f0500637e484e45364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fd3179efb200989bb42ccd5e47fdd1a669ff0d2b6a3d964bfc710a5c8427407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc3bfd2d99806f07b434c8a792bd102992819d57baab60c06a5136541832062c"
    sha256 cellar: :any_skip_relocation, ventura:        "cc4935ed01c4f42f682510275953e723c0804ef5d20588fb58ac8816cba4e254"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c915899114c6679ecc7fc1131acc801a23908b8aa4e1e3e24ac3c1f05b143c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1d95c53ccfe4bdeb9a1a3e117786e2f329b2464450c55aca2e7483d4db7417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4a910a87c1a73336e901186f8ded9dfd6ff21dfd94d6e30e4aab2507afec7f"
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