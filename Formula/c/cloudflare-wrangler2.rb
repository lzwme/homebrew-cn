require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.56.0.tgz"
  sha256 "7c005f3344094386e3de2f56b357facee97ecb813c0875acfe2c6ccea238445b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37b923aab5b1d62d7812a0638535ef7dfc10d3bdda204d778b56a71b19c901ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9fe53c3fa102173f7ccdf10f7889258e06021c08fc168bdab94f3f4679daf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d18b59badf75a65989025a3acc08a03779492010551a69e101ab3c28f7ab92"
    sha256 cellar: :any_skip_relocation, sonoma:         "e93a367306390d522f012531b990cc54ab71ed3ea96200c504ae3ffea903c2e2"
    sha256 cellar: :any_skip_relocation, ventura:        "c96c9a7351e8b72203720e0169e800190029c151b30c70a06a4193c9823f57af"
    sha256 cellar: :any_skip_relocation, monterey:       "cf7981d6c86b470be981296625d3773e8cf4bdd36551fb961ca2f2a5f7c79d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78001b1e932f8ee6621a85285e1d569e7eef03736f60030e0cd251f8fcca5bd"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end