require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.5.0.tgz"
  sha256 "de085cac338f52a079a9c93b4fa84bd5297d2c58fbf043c76e273b113dbecd79"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f3766bc5be28929383486b37fa65f0901b1750df34c1a2594f53817cea3bf9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf78ba3a51aeb9bac9ff0799b6d44c8f9873fe856d5113f223d7d7d8f4018fa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369d7fa24f01abae8bf46458c3878b99886cf8c80b6d8b22d88f24b3e8df3df1"
    sha256 cellar: :any_skip_relocation, ventura:        "8b8e0e0c9c9197a5c74c19db4fe3303d2bd89f6a6ed604fbdcbc60f954838a4c"
    sha256 cellar: :any_skip_relocation, monterey:       "80f7c74c0ab8c5613846bf02c387ffe672aed70cf801db25b433c5147aa2a386"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ffdfacebdcb5d8e23b59f4403327d5f370f4bfb334c5b0ed164873553a4936b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce777399dde7fe83e482c1a0d9f3535671b7ae228ad2d29d06ba8206cc8edf4b"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end