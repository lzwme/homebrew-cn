class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.21.2.tgz"
  sha256 "b301db48b533a64071a915bfe00c94a435086afd2d2ce87eb00f7d759892185f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1827cbd08a96210da2b8ff57ef5c7407a337ad2801a77a276ebcf2a95c8c736"
    sha256 cellar: :any,                 arm64_sonoma:  "e1827cbd08a96210da2b8ff57ef5c7407a337ad2801a77a276ebcf2a95c8c736"
    sha256 cellar: :any,                 arm64_ventura: "e1827cbd08a96210da2b8ff57ef5c7407a337ad2801a77a276ebcf2a95c8c736"
    sha256                               sonoma:        "69cb1aaa337df9d65cbe43bb7d18dda2f47f536db3c0bdf687182621bf00b6f2"
    sha256                               ventura:       "69cb1aaa337df9d65cbe43bb7d18dda2f47f536db3c0bdf687182621bf00b6f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44660993a25b7def4f9c0cf1d910c3451599d8ff9e204e3ff99248edc277397e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd10ea93842c8c9ca20a8bed6d2ffdcbee6f885b51d18982900aea2360164b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end