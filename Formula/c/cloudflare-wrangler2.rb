class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.69.1.tgz"
  sha256 "1d17917e115b1c0698d9f7071303c39e1675238940eea44c097688ae00064d10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "761a021d1c69ca72adb4a3ebc568a14591de7e4de34f8a22660d23d0f9345535"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761a021d1c69ca72adb4a3ebc568a14591de7e4de34f8a22660d23d0f9345535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "761a021d1c69ca72adb4a3ebc568a14591de7e4de34f8a22660d23d0f9345535"
    sha256 cellar: :any_skip_relocation, sonoma:         "187456c03dbb71670ee06011c1dd9cbd78b043cb5fe2612490b5879894a98c8c"
    sha256 cellar: :any_skip_relocation, ventura:        "187456c03dbb71670ee06011c1dd9cbd78b043cb5fe2612490b5879894a98c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "187456c03dbb71670ee06011c1dd9cbd78b043cb5fe2612490b5879894a98c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18649cd054669f1aa328606beb04648b446d402ff745147e3ce634b52cc9eca1"
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