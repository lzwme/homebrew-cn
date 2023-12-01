require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.18.0.tgz"
  sha256 "27f724cec7315bb525dfd7b6bb349b7e1ff77f2ac8c7ba4819060f8f3afde33f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4fe18846f627785b3b3e07545de7c671d4e5634ad6647e150699035e3adcff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4fe18846f627785b3b3e07545de7c671d4e5634ad6647e150699035e3adcff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4fe18846f627785b3b3e07545de7c671d4e5634ad6647e150699035e3adcff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "84a097a554acdf4aaf75cc6b0e9c81122a32d4b7c6ebaa40605d79ce34272077"
    sha256 cellar: :any_skip_relocation, ventura:        "84a097a554acdf4aaf75cc6b0e9c81122a32d4b7c6ebaa40605d79ce34272077"
    sha256 cellar: :any_skip_relocation, monterey:       "84a097a554acdf4aaf75cc6b0e9c81122a32d4b7c6ebaa40605d79ce34272077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecce6281469de6c884aa5cb2a9c9b3969f4603cadf72230d2dd0409e4fef8f4f"
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