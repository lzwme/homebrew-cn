class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.78.7.tgz"
  sha256 "dd4b77860364ffb3c868b8ab44c333c3eb6178653ca5df0c84ef3704a91132c7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27014cd7e63a7a395dc107c4cb405335cf8cff2d4375edc5cb60c1a79ff95e6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27014cd7e63a7a395dc107c4cb405335cf8cff2d4375edc5cb60c1a79ff95e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27014cd7e63a7a395dc107c4cb405335cf8cff2d4375edc5cb60c1a79ff95e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "85758ba695447c5e15721cee85c23ae2d869b6a37eb6029269501461cfc2466a"
    sha256 cellar: :any_skip_relocation, ventura:       "85758ba695447c5e15721cee85c23ae2d869b6a37eb6029269501461cfc2466a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab367ffbde6644ed6b7defe97244016c16c53d08f80a98e50cbf3ac55849d1e5"
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