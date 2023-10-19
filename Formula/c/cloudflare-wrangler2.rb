require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.13.2.tgz"
  sha256 "cabe009487fb39a35730a7e5fdf48f52b8bc79a0635e2523ae7afb7b279bbb68"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a37a3257be3aa1abd4c25fac030b04626a3abbfdb475c1641f188641d87df74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a37a3257be3aa1abd4c25fac030b04626a3abbfdb475c1641f188641d87df74e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a37a3257be3aa1abd4c25fac030b04626a3abbfdb475c1641f188641d87df74e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0341d1462399278570fbaa82912754b3b0d07d1a4bc24ce5badbe14f4362e09c"
    sha256 cellar: :any_skip_relocation, ventura:        "0341d1462399278570fbaa82912754b3b0d07d1a4bc24ce5badbe14f4362e09c"
    sha256 cellar: :any_skip_relocation, monterey:       "0341d1462399278570fbaa82912754b3b0d07d1a4bc24ce5badbe14f4362e09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b439bbc824627a53bc6515d8a7b137556fff3f26f68fd7b8ae36193b71dc3dc5"
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