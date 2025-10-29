class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.45.1.tgz"
  sha256 "87870120a3540a2eecf9e49c29dbe2516046fab1b31a27eac1624dc91f9dd3dc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "750bf826b59f94fb94c73d09cacdef6e9776b027278dbd2789057af4a15d700e"
    sha256 cellar: :any,                 arm64_sequoia: "e612df1fde9553d9fc28246793dacaae1503653f787037e086fb8519f1a3389e"
    sha256 cellar: :any,                 arm64_sonoma:  "e612df1fde9553d9fc28246793dacaae1503653f787037e086fb8519f1a3389e"
    sha256 cellar: :any,                 sonoma:        "eba7a862045b7673373d07417f56f1a7f6cd107f499cd260668bcea49cdf5231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5349116660562816f0e9dfaaccc164c9439c8970660b47c2ba9ed6c21a05d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c900521cc583770ecf340d0cf7a5c5d1798d6d589d559a99341f399c24db97"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end