class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.21.1.tgz"
  sha256 "fe26c3b94e789daf41ccf9bcaaed5ac392c741623121bd0e197572166cee25f4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b85df058b028ab098245f2546865025135d73302cc9e57877d7afee7bc9d5a28"
    sha256 cellar: :any,                 arm64_sonoma:  "b85df058b028ab098245f2546865025135d73302cc9e57877d7afee7bc9d5a28"
    sha256 cellar: :any,                 arm64_ventura: "b85df058b028ab098245f2546865025135d73302cc9e57877d7afee7bc9d5a28"
    sha256                               sonoma:        "024b955bfd9600c577a8e24044fd786c66f2c048fab8e5adcd7dc3b12c84abd1"
    sha256                               ventura:       "024b955bfd9600c577a8e24044fd786c66f2c048fab8e5adcd7dc3b12c84abd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d688d0ce1f10c04aa74a911ee3872650d922a42877481727a759d232d40e234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89845e43b2c5410f2b1e50b8e52b72d5135256bffc7077ea85bae58ba679f0c8"
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