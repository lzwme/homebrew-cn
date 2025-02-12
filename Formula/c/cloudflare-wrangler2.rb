class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.108.0.tgz"
  sha256 "c3e4dc19f04e9804625192802ed5a9c49ba12eff3b277839336a819871a80b3e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df2f4046685abde92ebb8946ebdbe9a767f9d9fdc07e21863b31ecfc8a5aa0c1"
    sha256 cellar: :any,                 arm64_sonoma:  "df2f4046685abde92ebb8946ebdbe9a767f9d9fdc07e21863b31ecfc8a5aa0c1"
    sha256 cellar: :any,                 arm64_ventura: "df2f4046685abde92ebb8946ebdbe9a767f9d9fdc07e21863b31ecfc8a5aa0c1"
    sha256                               sonoma:        "cb1151c75df5642ce4a03b968ef16868bb671d7df050201c8b9bdf3f52b98182"
    sha256                               ventura:       "cb1151c75df5642ce4a03b968ef16868bb671d7df050201c8b9bdf3f52b98182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7270736f51b4e6201788e7804d933de19b9149b86cc5864d7e31a033525e1708"
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